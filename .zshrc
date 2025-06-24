export DOTDIR=~/.config
export ZDOTDIR=$DOTDIR/zsh
export EDITOR='nvim'
# export TERM=xterm-256color
DEFAULT_USER='liamederzeel'

# Completion init
autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=10000
setopt appendhistory
export PATH="$PATH:/usr/local/mysql/bin:/usr/local/mysql/bin:/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/liamederzeel/.rvm/bin:$HOME/npm/bin:$HOME/.cargo/bin:$HOME/go/bin/"
export PATH=/Library/Frameworks/Mono.framework/Versions/Current/bin/:${PATH}
export PATH=~/.local/bin:${PATH}
export PATH=/usr/local/share/dotnet:${PATH}
export PATH=/Library/Frameworks/Mono.framework/Versions/Current/bin:${PATH}
export PATH=/System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources:${PATH}
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:${PATH}
# export PATH=/run/current-system/sw/bin:${PATH}

source "$ZDOTDIR/zsh-functions"
# autosurgestions
sourceplug "zsh-users/zsh-autosuggestions"
# syntax highlighting
sourceplug "zsh-users/zsh-syntax-highlighting"

source_save $ZDOTDIR/plugins/kubectl-autocompletion.plugin.zsh
# prompt
source_save $ZDOTDIR/zsh-prompt
# completion
source_save $ZDOTDIR/zsh-completion
# fzf history completion
source_save ~/.fzf.zsh

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

# aliases
source_save $ZDOTDIR/zsh-aliases


if exists_in_path exa; then 
  alias ls='eza --icons=always '
  export EXA_ICON_SPACING=2; 
fi

# Key-bindings
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^n' up-line-or-beginning-search
bindkey '^p' down-line-or-beginning-search
bindkey -s '^x' '^usource ~/.zshrc\n'
bindkey '^ ' autosuggest-accept


if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opam configuration
[[ ! -r /Users/liamederzeel/.opam/opam-init/init.zsh ]] || source /Users/liamederzeel/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# pnpm
export PNPM_HOME="/Users/liamederzeel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
docker_remove_unamed_volumes () {
  docker volume ls -q | grep -E '^[0-9a-f]{64}$' | xargs docker volume rm
}

source_save ~/.zshenv

# zoxide init
eval "$(zoxide init zsh)"

_tv_smart_autocomplete() {
    emulate -L zsh
    zle -I

    local current_prompt
    current_prompt=$LBUFFER

    local output

    output=$(tv --autocomplete-prompt "$current_prompt" $*)


    if [[ -n $output ]]; then
        zle reset-prompt
        RBUFFER=""
        # add a space if the prompt does not end with one
        [[ "${current_prompt}" != *" " ]] && current_prompt="${current_prompt} "
        LBUFFER=$current_prompt$output

        # uncomment this to automatically accept the line
        # (i.e. run the command without having to press enter twice)
        # zle accept-line
    fi
}

_tv_shell_history() {
    emulate -L zsh
    zle -I

    local current_prompt
    current_prompt=$LBUFFER

    local output

    output=$(tv zsh-history --input "$current_prompt" $*)


    if [[ -n $output ]]; then
        zle reset-prompt
        RBUFFER=""
        LBUFFER=$output

        # uncomment this to automatically accept the line
        # (i.e. run the command without having to press enter twice)
        # zle accept-line
    fi
}


zle -N tv-smart-autocomplete _tv_smart_autocomplete
zle -N tv-shell-history _tv_shell_history


bindkey '^T' tv-smart-autocomplete
bindkey '^R' tv-shell-history
