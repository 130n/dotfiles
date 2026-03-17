# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  direnv
  docker
  npm
  python
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Secrets (API keys etc) - loaded from ~/.secrets
[[ -f ~/.secrets ]] && source ~/.secrets

# Claude Code / Anthropic
export CLAUDE_CODE_USE_FOUNDRY=1
export ANTHROPIC_FOUNDRY_BASE_URL=https://ai-agents-dev-001.services.ai.azure.com/anthropic
export ANTHROPIC_DEFAULT_SONNET_MODEL='claude-sonnet-4-5'
export ANTHROPIC_DEFAULT_HAIKU_MODEL='claude-haiku-4-5'
export ANTHROPIC_DEFAULT_OPUS_MODEL='claude-opus-4-6'
export ANTHROPIC_MODEL=$ANTHROPIC_DEFAULT_OPUS_MODEL

# Map Foundry variables to standard Anthropic variables for Claude Code compatibility
export ANTHROPIC_API_KEY="$ANTHROPIC_FOUNDRY_API_KEY"
export ANTHROPIC_BASE_URL="$ANTHROPIC_FOUNDRY_BASE_URL"



# direnv
eval "$(direnv hook zsh)"

# Dotfiles
source ~/dotfiles/aliases.sh
source ~/dotfiles/functions.sh
source ~/dotfiles/worktree-helpers.sh

# Git push with Azure DevOps PR link
git-pushpr() {
    git push "$@"

    if [ $? -eq 0 ]; then
        local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        local REMOTE_URL=$(git remote get-url origin 2>/dev/null)
        local ORG PROJECT REPO

        if [[ $REMOTE_URL =~ git@ssh\.dev\.azure\.com:v3/([^/]+)/([^/]+)/([^/]+) ]]; then
            ORG="${match[1]}"
            PROJECT="${match[2]}"
            REPO="${match[3]}"
        elif [[ $REMOTE_URL =~ https://dev\.azure\.com/([^/]+)/([^/]+)/_git/(.+) ]]; then
            ORG="${match[1]}"
            PROJECT="${match[2]}"
            REPO="${match[3]}"
        fi

        if [ -n "$ORG" ] && [ -n "$PROJECT" ] && [ -n "$REPO" ]; then
            local PR_URL="https://dev.azure.com/${ORG}/${PROJECT}/_git/${REPO}/pullrequestcreate?sourceRef=${BRANCH}&targetRef=dev"
            echo ""
            echo "✓ Pushed successfully!"
            echo ""
            echo "Create PR: ${PR_URL}"
            echo ""
        fi
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

fpath+=~/.zfunc

# CLI access token for replay script
export CLI_ACCESS_TOKEN_FILE="/tmp/mytoken.txt"
[[ -f "$CLI_ACCESS_TOKEN_FILE" ]] && export CLI_ACCESS_TOKEN=$(cat "$CLI_ACCESS_TOKEN_FILE" | tr -d '\n')

setmytoken() {
    local token="${1#Bearer }"
    echo -n "$token" > "$CLI_ACCESS_TOKEN_FILE"
    export CLI_ACCESS_TOKEN="$token"
    echo "Token saved and exported (${#token} chars)"
}

# nvm - lazy loaded for faster shell startup
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm node npm npx pnpm corepack
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() { nvm use default >/dev/null 2>&1; unset -f node; command node "$@"; }
npm() { nvm use default >/dev/null 2>&1; unset -f npm; command npm "$@"; }
npx() { nvm use default >/dev/null 2>&1; unset -f npx; command npx "$@"; }
pnpm() { nvm use default >/dev/null 2>&1; unset -f pnpm; command pnpm "$@"; }
corepack() { nvm use default >/dev/null 2>&1; unset -f corepack; command corepack "$@"; }
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
