# Make completion - extract targets from Makefile
_make_targets() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if [[ -f Makefile ]]; then
        local targets=$(grep -oE '^[a-zA-Z0-9_-]+:' Makefile | sed 's/://')
        COMPREPLY=($(compgen -W "$targets" -- "$cur"))
    fi
}
complete -F _make_targets make
