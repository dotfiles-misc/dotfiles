#!/usr/bin/bash
#echo 'zshrc' $0 # Debug
# Profiling
# zmodload zsh/zprof

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd nomatch
# zle uses vi mode
bindkey -v
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall

# zstyle ':completion:*' completer _expand _complete _ignored _approximate
# zstyle :compinstall filename '/Users/timosand/.zshrc'

# autoload -Uz compinit && compinit
# End of lines added by compinstall

# oh-my-zsh
# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want disable red dots displayed while waiting for completion
# DISABLE_COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(
  extract
  ssh-agent
  tmux
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
# end oh-my-zsh

if [ -f $HOME/dotfiles/config/enhancd/init.sh ]; then source $HOME/dotfiles/config/enhancd/init.sh; fi

# Set editor
set -o vi

# Announces todays date
today=$(date "+%m.%d.%Y")


# Colors
autoload -U colors && colors
setopt prompt_subst

eval $(dircolors ~/.dir_colors)

# ZSH Hooks
autoload -U add-zsh-hook

# Disable correct
if [ -f ~/.zsh_nocorrect ]; then
    while read -r COMMAND; do
        alias $COMMAND="nocorrect $COMMAND"
    done < ~/.zsh_nocorrect
fi

# all of our zsh files
typeset -U config_files
config_files=(~/.zsh/*.zsh)

# load the path files
for file in $config_files
do
  source "$file"
done

init_files=(~/.zsh/init/*.*sh)

for file in $init_files
do
    source "$file" || true
done

setopt extendedglob

tmux list-sessions 2> /dev/null

# compinit
# autoload -U +X bashcompinit && bashcompinit

if [ $commands[kubectl] ]; then source <(kubectl completion zsh); fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
neofetch

# Profiling end
# zprof
