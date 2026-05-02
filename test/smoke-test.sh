#!/bin/bash
# Fast smoke test: verifies every pacman/yay package referenced in arch.sh
# is currently installable in a clean archlinux:base-devel container, and
# every curl URL is reachable. Runs in under a minute.
#
# Catches: package renames/removals (the #1 cause of breakage on a fresh
# install), dead URLs.
# Does NOT catch: ordering bugs, runtime failures. Use test/dryrun.sh for
# logic flow, or test/qemu-vm.sh for true end-to-end.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARCH_SH="$DOTFILES/arch.sh"
IMAGE="archlinux:base-devel"

# ---------- 1. Bash syntax ----------
echo "==> bash -n on arch.sh + symlink_arch.sh"
bash -n "$DOTFILES/arch.sh"
bash -n "$DOTFILES/symlink_arch.sh"
echo "    OK"

# ---------- 2. Extract package names ----------
# Scan every `pacman -S ... <pkgs>` and `yay -S ... <pkgs>` invocation.
# Skip flags (anything starting with -) and continuation backslashes.
echo
echo "==> Extracting pacman + yay package lists from arch.sh"

extract_packages() {
    local cmd="$1"  # "pacman" or "yay"
    awk -v cmd="$cmd" '
        # Find lines with the command and -S
        $0 ~ "(^|[^a-zA-Z])"cmd"[[:space:]]+-S" {
            in_block = 1
        }
        in_block {
            # Strip everything up to and including -S(yu)? --noconfirm --needed
            gsub(/.*-S(yu)?[[:space:]]+/, "")
            gsub(/--noconfirm|--needed|sudo|yay|pacman|-S|-Syu/, "")
            gsub(/\\$/, "")  # trailing line-continuation
            for (i = 1; i <= NF; i++) {
                if ($i !~ /^-/ && $i !~ /^[<>|;]/ && $i != "" && $i !~ /^[\[#]/) {
                    print $i
                }
            }
            if ($0 !~ /\\$/) in_block = 0
        }
    ' "$ARCH_SH" | sort -u
}

PACMAN_PKGS=$(extract_packages pacman)
YAY_PKGS=$(extract_packages yay)

echo "    Found $(echo "$PACMAN_PKGS" | wc -l) pacman packages, $(echo "$YAY_PKGS" | wc -l) AUR packages"

# ---------- 3. URLs ----------
echo
echo "==> Extracting curl URLs"
# Skip *.git URLs — git smart-HTTP doesn't serve HEAD on these endpoints,
# they need `git ls-remote` instead. We trust them for now.
URLS=$(grep -oE 'https?://[^[:space:]"'\'']+' "$ARCH_SH" | grep -v '\.git$' | sort -u)
echo "    Found $(echo "$URLS" | wc -l) URLs"

# ---------- 4. Validate packages in a fresh container ----------
echo
echo "==> Pulling $IMAGE (cached if present)"
podman pull -q "$IMAGE" >/dev/null

echo
echo "==> Refreshing pacman db inside container + checking each package"
MISSING_PACMAN=$(printf '%s\n' "$PACMAN_PKGS" | podman run --rm -i "$IMAGE" bash -s <<'INNER'
pacman -Sy --noconfirm >/dev/null 2>&1
while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    if ! pacman -Si "$pkg" >/dev/null 2>&1; then
        echo "$pkg"
    fi
done
INNER
)

if [ -n "$MISSING_PACMAN" ]; then
    echo "    FAIL: missing from official repos:"
    echo "$MISSING_PACMAN" | sed 's/^/      - /'
    PACMAN_OK=0
else
    echo "    PASS: all pacman packages resolve"
    PACMAN_OK=1
fi

# ---------- 5. AUR packages: just check the AUR RPC ----------
echo
echo "==> Checking AUR packages via aur.archlinux.org RPC"
MISSING_AUR=""
for pkg in $YAY_PKGS; do
    resp=$(curl -fsS "https://aur.archlinux.org/rpc/v5/info?arg[]=$pkg" 2>/dev/null || echo '{}')
    count=$(echo "$resp" | grep -oE '"resultcount":[[:space:]]*[0-9]+' | grep -oE '[0-9]+$' || echo 0)
    if [ "$count" -eq 0 ]; then
        MISSING_AUR="$MISSING_AUR $pkg"
    fi
done
if [ -n "$MISSING_AUR" ]; then
    echo "    FAIL: missing from AUR:$MISSING_AUR"
    AUR_OK=0
else
    echo "    PASS: all AUR packages resolve"
    AUR_OK=1
fi

# ---------- 6. URLs ----------
echo
echo "==> Checking URLs (HEAD)"
URL_FAIL=""
while IFS= read -r url; do
    [ -z "$url" ] && continue
    code=$(curl -sI -o /dev/null -w "%{http_code}" --max-time 10 -L "$url" || echo "000")
    if [[ ! "$code" =~ ^(200|301|302|307|308)$ ]]; then
        URL_FAIL="$URL_FAIL\n  $code  $url"
    fi
done <<< "$URLS"

if [ -n "$URL_FAIL" ]; then
    echo -e "    WARN: non-2xx/3xx responses (may still work — some hosts block HEAD):$URL_FAIL"
    URL_OK=0
else
    echo "    PASS: all URLs reachable"
    URL_OK=1
fi

# ---------- 7. Summary ----------
echo
echo "================================="
echo "         SMOKE TEST RESULT"
echo "================================="
echo "  bash syntax    : OK"
[ "$PACMAN_OK" = 1 ] && echo "  pacman packages: OK" || echo "  pacman packages: FAIL"
[ "$AUR_OK"    = 1 ] && echo "  AUR packages   : OK" || echo "  AUR packages   : FAIL"
[ "$URL_OK"    = 1 ] && echo "  URLs           : OK" || echo "  URLs           : WARN"

if [ "$PACMAN_OK" = 1 ] && [ "$AUR_OK" = 1 ]; then
    echo
    echo "Packages all resolve. For full end-to-end test run test/qemu-vm.sh."
    exit 0
else
    exit 1
fi
