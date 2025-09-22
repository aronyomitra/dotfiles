alias python="python3"
alias nano="nano -x"

fcd() {
  local dir
  dir=$(find . -type d | fzf)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}
