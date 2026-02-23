#!/usr/bin/env bash
# Claude Code status line - based on PS1 from ~/.profile
# PS1 was: $ \W :.

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Detect git worktrees.
# git rev-parse --show-toplevel  → the root of the current worktree
# git rev-parse --git-common-dir → the shared .git dir (lives inside the main
#   repo for linked worktrees, e.g. /path/to/main/.git/worktrees/my-branch)
#
# In a normal (non-worktree) checkout the common dir is ".git" (relative) or
# an absolute path whose parent equals --show-toplevel.
# In a linked worktree the common dir is an absolute path whose parent is NOT
# the current worktree root, which lets us identify the main repo root.

dir_label=""
if [ -n "$cwd" ]; then
  worktree_root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
  common_dir=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)

  if [ -n "$worktree_root" ] && [ -n "$common_dir" ]; then
    # Resolve common_dir to an absolute path when git returns a relative one.
    case "$common_dir" in
      /*) abs_common_dir="$common_dir" ;;
      *)  abs_common_dir="${worktree_root}/${common_dir}" ;;
    esac

    # The main repo root: for normal repos common_dir ends in /.git so its
    # parent is the repo root.  For bare repos common_dir IS the repo root.
    case "$abs_common_dir" in
      */.git) main_root=$(dirname "$abs_common_dir") ;;
      *)      main_root="$abs_common_dir" ;;
    esac

    if [ "$main_root" != "$worktree_root" ]; then
      # We are inside a linked worktree.
      main_name=$(basename "$main_root")
      worktree_name=$(basename "$worktree_root")
      dir_label="${main_name}/${worktree_name}"
    fi
  fi
fi

# Fall back to the plain basename of cwd when not in a worktree (or outside git).
if [ -z "$dir_label" ]; then
  dir_label=$(basename "$cwd")
fi

# Get git branch if in a repo.
git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Build status line from PS1: \W :.
status="${dir_label} :."
if [ -n "$git_branch" ]; then
  status="${status}  ${git_branch}"
fi

# Append model name
if [ -n "$model" ]; then
  status="${status}  [${model}]"
fi

# Append context usage if available
if [ -n "$used_pct" ]; then
  printf_pct=$(printf "%.0f" "$used_pct")
  status="${status}  ctx:${printf_pct}%"
fi

printf "%s" "$status"
