export DOTDIR=~/.config
export ZDOTDIR=$DOTDIR/zsh
export EDITOR='nvim'
export TERM=xterm-256color
DEFAULT_USER='liamederzeel'

export EXA_ICON_SPACING=2

HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=10000
setopt appendhistory

export PATH="/usr/local/mysql/bin:/usr/local/mysql/bin:/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/liamederzeel/.rvm/bin:$HOME/npm/bin:$HOME/.cargo/bin"
export PATH=/Library/Frameworks/Mono.framework/Versions/Current/bin/:${PATH}
export PATH=~/.local/bin:${PATH}
export PATH=/usr/local/share/dotnet:${PATH}
export PATH=/Library/Frameworks/Mono.framework/Versions/Current/bin:${PATH}
export PATH=/System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources:${PATH}
# export PATH=/run/current-system/sw/bin:${PATH}

source "$ZDOTDIR/zsh-functions"
# autosurgestions
sourceplug "zsh-users/zsh-autosuggestions"
# syntax highlighting
sourceplug "zsh-users/zsh-syntax-highlighting"
# prompt
source_save $ZDOTDIR/zsh-prompt
# completion
source_save $ZDOTDIR/zsh-completion
# fzf history completion
source_save ~/.fzf.zsh

alias git-clean="git remote prune origin && git branch --merged | grep -i -v -E 'master|dev'| xargs git branch -d"
alias configlg='lazygit --work-tree ~ --git-dir ~/.dots'
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
alias tmux="env TERM=xterm-256color tmux"
alias v='~/.local/bin/lvim '
alias lvim='~/.local/bin/lvim '
alias work='cd ~/projects/whas'
alias lg='lazygit'
alias ld='lazydocker'
alias k="minikube kubectl --"
alias m='minikube'
alias d='docker'
alias dc='docker compose'
alias sudo='sudo '
alias p='project-launcher -d ~/projects/personal -d ~/projects/whas'

if exists_in_path exa; then alias ls='exa --icons'; fi

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# . /Users/liamederzeel/.nix-profile/etc/profile.d/nix.sh

# . $HOME/.nix-profile/etc/profile.d/nix.sh
# if [ -e /Users/liamederzeel/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/liamederzeel/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^n' up-line-or-beginning-search
bindkey '^p' down-line-or-beginning-search
bindkey -s '^x' '^usource ~/.zshrc\n'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

bindkey '^ ' autosuggest-accept
