# vi:syntax=zsh
#echo 'zprofile' $0 # Debug
#setopt xtrace # Trace
#setopt promptsubst
#typeset -F SECONDS
#PS4='+{$SECONDS}%N:%i> '
# Locale settings
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# Base16 Shell
BASE16_SCHEME="flat"
BASE16_SHELL="$HOME/dotfiles/config/base16/shell/base16-$BASE16_SCHEME.dark.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

# Customize to your needs...
BIN_PATH="$HOME/bin:$HOME/local/bin" # Add ~/bin to PATH
BOX_PATH="$HOME/dotfiles/box/bin" # Add path for box
CABAL_PATH="$HOME/.cabal/bin"
STACK_INSTALL_PATH="$HOME/.local/bin/"
PATH=$BIN_PATH:$BOX_PATH:$PATH
export GOPATH="$HOME/go"
export NVM_DIR="$HOME/.nvm"

PATH=$CABAL_PATH:$STACK_INSTALL_PATH:$PATH

case $OSTYPE in
    darwin*)
        COREUTILS_PATH=/usr/local/opt/coreutils/libexec/gnubin
        HOMEBREW_PATH=/usr/local/sbin:/usr/local/bin
        PATH=$COREUTILS_PATH:$HOMEBREW_PATH:$PATH
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
        export RBENV_ROOT=/usr/local/var/rbenv
        export ARCHFLAGS="-arch x86_64"
        export JAVA_HOME=$(/usr/libexec/java_home)
        export SCALA_HOME=/usr/local/opt/scala
        export ATOM_REPOS_HOME=$HOME/Dropbox/Documents/Projects
    ;;
    *)
        export RBENV_ROOT=~/.rbenv
    ;;
esac

PATH="$RBENV_ROOT/bin:$PATH"

typeset -U PATH
export PATH

# Make path system wide for OS X
case $OSTYPE in
    darwin*)
      if test -f ~/.gnupg/.gpg-agent-info -a -n "$(pgrep gpg-agent)"; then
        source ~/.gnupg/.gpg-agent-info
        export GPG_AGENT_INFO
        GPG_TTY=$(tty)
        export GPG_TTY
      else
        eval $(gpg-agent --daemon --write-env-file ~/.gnupg/.gpg-agent-info)
      fi
    ;;
esac

#if [[ ! $(type perlbrew) =~ "shell function" ]]; then source ~/perl5/perlbrew/etc/bashrc; fi
if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
eval $(thefuck --alias)
