# Uncomment to profile startup time (same for last line
# zmodload zsh/zprof
# Path to your oh-my-zsh installation.
LANG="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
export ZSH=${HOME}/.oh-my-zsh
MAILCHECK=0

DEBUG=false
#set -x
$DEBUG && echo "debugging startup"

# Remove user@machine
#DEFAULT_USER=`whoami`

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster-leon"
ZSH_THEME="gozilla"
ZSH_THEME="miloshadzic"
#ZSH_THEME="leon-miloshadzic"
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
#    jsontools
#    virtualenv
    zsh-autosuggestions
    zsh-syntax-highlighting
    git
)

clocknow() {
	echo -n `date +%H:%M:%S`" "
}

$DEBUG && clocknow && echo "init oh-my-zsh"
source $ZSH/oh-my-zsh.sh
$DEBUG && clocknow && echo "oh-my-zsh"
# User configuration


source ~/.exports
$DEBUG && clocknow && echo "exports"
source ~/.aliases
$DEBUG && clocknow && echo "aliases"
source ~/.functions
$DEBUG && clocknow && echo "functions"
ssh-add -K $HOME/.ssh/id_rsa > /dev/null 2>&1
$DEBUG && clocknow && echo "ssh add"

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh
$DEBUG && clocknow && echo "iterm2"

# Default to whatever is set in workmode file, source SBAB-config initially and setup toggle alias
test -e ~/.workmode && source ~/.workmode
$DEBUG && clocknow && echo "workmode"

# Uncomment to profile startup time (same for first line)
# zprof

export PATH=$PATH:/Users/lhen/.nvm/versions/node/v16.20.0/bin #current version
lazy_load_nvm() {
	$DEBUG && clocknow && echo "lazy nvm: start"
	unset -f npm node nvm yarn
	export NVM_DIR="$HOME/.nvm"
	[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
	[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	$DEBUG && clocknow && echo "lazy nvm: done"
}
node() {
  lazy_load_nvm
  node $@
}
npm() {
  lazy_load_nvm
  npm $@
}
yarn() {
  lazy_load_nvm
  yarn $@
}
nvm() {
  lazy_load_nvm
  nvm $@
}
#$DEBUG && clocknow && echo "nvm_init"

$DEBUG && clocknow && echo "sbabrc"
test -e ~/.sbabrc && source ~/.sbabrc

$DEBUG && clocknow && echo "DONE"


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# pnpm
export PNPM_HOME="/Users/lhen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
