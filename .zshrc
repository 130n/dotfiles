# Uncomment to profile startup time (same for last line
# zmodload zsh/zprof
# Path to your oh-my-zsh installation.
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
export ZSH=${HOME}/.oh-my-zsh

# Remove user@machine
#DEFAULT_USER=`whoami`

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster-leon"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    jsontools
    #virtualenvwrapper
    virtualenv
    zsh-autosuggestions
    zsh-syntax-highlighting
    git
)

source $ZSH/oh-my-zsh.sh

# User configuration


source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.nvm_init


ssh-add -K $HOME/.ssh/id_rsa > /dev/null 2>&1
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Default to whatever is set in workmode file, source SBAB-config initially and setup toggle alias
test -e ~/.workmode && source ~/.workmode
test -e ~/.sbabrc && source ~/.sbabrc

# Uncomment to profile startup time (same for first line)
# zprof

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
