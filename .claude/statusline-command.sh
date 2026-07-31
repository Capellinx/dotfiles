#!/usr/bin/env bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 0')

five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')

# Git info (skip if not a git repo)
git_branch=""
git_status_part=""
git_commit=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

    # Count staged + unstaged + untracked changes
    dirty_count=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')

    # Last commit: short hash + relative time
    git_commit=$(git -C "$cwd" log -1 --format="%h %cr" 2>/dev/null | sed 's/ seconds\? ago/s ago/;s/ minutes\? ago/m ago/;s/ hours\? ago/h ago/;s/ days\? ago/d ago/;s/ weeks\? ago/w ago/;s/ months\? ago/mo ago/')
fi

# CI status via gh (non-blocking, 3s timeout)
ci_status=""
if command -v gh >/dev/null 2>&1 && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    ci_raw=$(gh run list --limit 1 --json conclusion,status -q '.[0] | "\(.status) \(.conclusion)"' 2>/dev/null)
    ci_run_status=$(echo "$ci_raw" | awk '{print $1}')
    ci_conclusion=$(echo "$ci_raw" | awk '{print $2}')
    if [ "$ci_conclusion" = "success" ]; then
        ci_status="ok"
    elif [ "$ci_conclusion" = "failure" ] || [ "$ci_conclusion" = "cancelled" ]; then
        ci_status="fail"
    elif [ "$ci_run_status" = "in_progress" ] || [ "$ci_run_status" = "queued" ]; then
        ci_status="running"
    fi
fi

# ANSI colors
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
MAGENTA="\033[35m"

parts=()

# Directory + model
parts+=("$(printf "${CYAN}%s${RESET}" "$dir") $(printf "${DIM}%s${RESET}" "$model")")

# Context window usage
if [ -n "$used_pct" ]; then
    used_int=$(printf "%.0f" "$used_pct")
    if [ "$used_int" -ge 80 ]; then
        color="$RED"
    elif [ "$used_int" -ge 50 ]; then
        color="$YELLOW"
    else
        color="$GREEN"
    fi
    ctx_bar="$(printf "${color}ctx:${used_int}%%${RESET}")"

    if [ "$ctx_size" -gt 0 ]; then
        total_k=$(( (total_in + total_out) / 1000 ))
        ctx_k=$(( ctx_size / 1000 ))
        ctx_bar="$ctx_bar $(printf "${DIM}%dk/%dk${RESET}" "$total_k" "$ctx_k")"
    fi
    parts+=("$ctx_bar")
fi

# Rate limits
rate_parts=""
if [ -n "$five_pct" ]; then
    five_int=$(printf "%.0f" "$five_pct")
    if [ "$five_int" -ge 80 ]; then color="$RED"
    elif [ "$five_int" -ge 50 ]; then color="$YELLOW"
    else color="$GREEN"
    fi
    rate_parts="$(printf "${color}5h:${five_int}%%${RESET}")"
fi
if [ -n "$week_pct" ]; then
    week_int=$(printf "%.0f" "$week_pct")
    if [ "$week_int" -ge 80 ]; then color="$RED"
    elif [ "$week_int" -ge 50 ]; then color="$YELLOW"
    else color="$GREEN"
    fi
    [ -n "$rate_parts" ] && rate_parts="$rate_parts "
    rate_parts="$rate_parts$(printf "${color}7d:${week_int}%%${RESET}")"
fi
[ -n "$rate_parts" ] && parts+=("$rate_parts")

# Git branch + status
if [ -n "$git_branch" ]; then
    if [ "$dirty_count" -eq 0 ]; then
        parts+=("$(printf "${GREEN}%s ✓${RESET}" "$git_branch")")
    else
        parts+=("$(printf "${RED}%s ●%s${RESET}" "$git_branch" "$dirty_count")")
    fi
fi

# Last commit
if [ -n "$git_commit" ]; then
    parts+=("$(printf "${DIM}%s${RESET}" "$git_commit")")
fi

# CI status
if [ -n "$ci_status" ]; then
    if [ "$ci_status" = "ok" ]; then
        parts+=("$(printf "${GREEN}CI:✓${RESET}")")
    elif [ "$ci_status" = "fail" ]; then
        parts+=("$(printf "${RED}CI:✗${RESET}")")
    elif [ "$ci_status" = "running" ]; then
        parts+=("$(printf "${YELLOW}CI:…${RESET}")")
    fi
fi

# Vim mode
if [ -n "$vim_mode" ]; then
    if [ "$vim_mode" = "INSERT" ]; then
        parts+=("$(printf "${GREEN}INSERT${RESET}")")
    else
        parts+=("$(printf "${MAGENTA}NORMAL${RESET}")")
    fi
fi

# Join parts with separator
result=""
sep="$(printf " ${DIM}|${RESET} ")"
for part in "${parts[@]}"; do
    if [ -z "$result" ]; then
        result="$part"
    else
        result="$result$sep$part"
    fi
done

printf "%b\n" "$result"
