export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

plugins=(
 brew
 git
 zsh-autosuggestions
 zsh-syntax-highlighting
)

VIRTUAL_ENV_DISABLE_PROMPT=1

source $ZSH/oh-my-zsh.sh

# agnoster: hide user@host
DEFAULT_USER="$USER"

# nvm (brew, Apple Silicon)
export NVM_DIR="$HOME/.nvm"
[ -s /opt/homebrew/opt/nvm/nvm.sh ] && \. /opt/homebrew/opt/nvm/nvm.sh
[ -s /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm ] && \. /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm
