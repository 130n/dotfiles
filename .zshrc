# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
#PATH=/usr/local/bin:$PATH
#PATH=$HOME/bin:$PATH
#export PATH

# Remove user@machine
#DEFAULT_USER=`whoami`

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster-leon"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

DISABLE_AUTO_TITLE="true"

COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(jsontools, virtualenvwrapper, virtualenv)

# User configuration

source $ZSH/oh-my-zsh.sh

# Personal files
if [ -f ~/.exports ]; then
    . ~/.exports
fi
if [ -f ~/.nyps_profile ]; then
    . ~/.assessio_profile
fi

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
#if [ -f ~/.nyps_functions ]; then
#    . ~/.nyps_functions
#fi
if [ -f ~/.functions ]; then
    . ~/.functions
fi

# run startup shizzle
eval $(thefuck --alias)
archey -c

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
