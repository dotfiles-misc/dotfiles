#!/usr/bin/bash
# vim syn=zsh

#echo 'zprofile' $0 # Debug
#setopt xtrace # Trace
#setopt promptsubst
#typeset -F SECONDS
#PS4='+{$SECONDS}%N:%i> '
# Locale settings
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# Customize to your needs...
BIN_PATH="$HOME/bin:$HOME/local/bin" # Add ~/bin to PATH
BOX_PATH="$HOME/dotfiles/box/bin" # Add path for box
CABAL_PATH="$HOME/.cabal/bin"
STACK_INSTALL_PATH="$HOME/.local/bin/"
PYTHON_BIN_PATH="$HOME/Library/Python/3.7/bin"
PATH=$BIN_PATH:$BOX_PATH:$PATH
export GOPATH="$HOME/go:$HOME/Dropbox/Documents/Projects"

PATH=${GOPATH//://bin:}/bin:$CABAL_PATH:$STACK_INSTALL_PATH:$PYTHON_BIN_PATH:$PATH

case $OSTYPE in
    darwin*)
        PYTHON_HOMEBREW_PATH=/usr/local/opt/python/libexec/bin
        COREUTILS_PATH=/usr/local/opt/coreutils/libexec/gnubin
        HOMEBREW_PATH=/usr/local/sbin:/usr/local/bin
        PATH=$COREUTILS_PATH:$PYTHON_HOMEBREW_PATH:$HOMEBREW_PATH:$PATH
        export RBENV_ROOT=/usr/local/var/rbenv
        export ARCHFLAGS="-arch x86_64"
        export JAVA_HOME
        JAVA_HOME=$(/usr/libexec/java_home)
        export SCALA_HOME=/usr/local/opt/scala
    ;;
    *)
        export RBENV_ROOT=$HOME/.rbenv
    ;;
esac

PATH="$RBENV_ROOT/bin:$PATH"

typeset -U PATH
export PATH

if [ -f $HOME/dotfiles/config/enhancd/init.sh ]; then source $HOME/dotfiles/config/enhancd/init.sh; fi
if type rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
if type nodenv > /dev/null; then eval "$(nodenv init - --no-rehash)"; fi
if type fasd > /dev/null; then eval "$(fasd --init auto)"; fi
if type thefuck > /dev/null; then eval "$(thefuck --alias)"; fi
if type direnv > /dev/null; then eval "$(direnv hook zsh)"; fi
