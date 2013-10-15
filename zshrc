# zsh runtime config
# Che-Huai Lin <lzh9102@gmail.com>

# custom completion scripts
fpath=(~/.zsh/completion $fpath)

# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_space

bindkey -e # emacs-style keybindings
setopt rmstarsilent # don't confirm 'rm *'
unsetopt beep
setopt extended_glob
unsetopt glob_dots # don't match dot files by *

# enable auto completion
autoload -U compinit && compinit

# completion settings
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=(${(s.:.)LS_COLORS})'
zstyle ':completion:*' accept-exact false

# killall completion
zstyle ':completion:*:processes-names' command 'ps -e -o comm='

# command line prompt
autoload -U colors && colors
PROMPT=
#PROMPT+="%(?..[%{$fg_bold[red]%}%?%{$reset_color%}])" # show error if exit status is non-zero
PROMPT+="%{$fg_bold[cyan]%}%n:%{$reset_color%}"
PROMPT+="%{$fg_bold[green]%}%~%{$reset_color%}"
PROMPT+="%{$fg_bold[cyan]%}>%{$reset_color%} "
RPROMPT="%{$fg[yellow]%}(%*)%{$reset_color%}"
# characters considered as part of a word
WORDCHARS="*?_-.[]~=&;!#$%^(){}<>"

# handle command-not-found
command_not_found_handler() {
	echo "command not found: $1"
	return 0
}

# system-specific settings
[ -f ~/.zshrc-local ] && source ~/.zshrc-local
