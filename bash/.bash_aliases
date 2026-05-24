alias python="python3"
alias nv=nvim
alias bcat=batcat
alias gpgkill="gpgconf --kill gpg-agent"
alias delta1="delta --config ~/.config/delta/lazygit-side.gitconfig"

# Search and change to a directory
fcd() {
  local dir
  dir=$(find . -type d | fzf)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}

# Trigger GPG passphrase caching
passauth() {
  if pass show dummy/auth >/dev/null 2>&1; then
    :
  else
    echo "GPG Unlock Failed"
  fi
}

# Open in neovim
nvo() {
    local response
    response=$(fd --hidden --exclude .git --exclude node_modules --exclude .venv "$@" . | fzf)
    if [ -n "$response" ]; then
        if [ -d "$response" ]; then
            cd "$response"
            nvim "."
        else
            nvim "$response"
        fi
    fi
}

# Starship prompt setup
eval "$(starship init bash)"

export COLORTERM=truecolor

# NVM setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Set the default editor to vim
export EDITOR="vim"

# Used by GPG to ask for the passphrase in the terminal
export GPG_TTY=$(tty)

# Custom paths
export PATH="~/bin:$PATH"
