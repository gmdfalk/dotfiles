if ! command -v clear &>/dev/null; then
    alias clear='printf "\033c"'
fi
if command -v hub &>/dev/null; then
    alias git=hub
fi