# dotfile utils - z used to be for zsh but also good to avoid collisions
alias rz="source ~/.zshrc"
alias ez="vim ~/.zshrc"
alias ea="vim ~/dotfiles/aliases.sh"

# Git aliases (custom, complements oh-my-zsh git plugin)
alias gs='git status'
alias gcd='git checkout dev'
alias gpr='git pull --rebase'
alias todo="nvim ~/dev/todo/TODO.org"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Color support for ls and grep
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias dev='cd ~/dev'
alias repo='cd ~/dev/AI-EmailToOrder'
alias backend='cd ~/dev/AI-EmailToOrder/backend'
alias frontend='cd ~/dev/AI-EmailToOrder/frontend'

# Dev tools
alias nvim-diff='git diff --name-only dev...HEAD | xargs nvim -p'

# Claude Code
alias yolo='claude-named --dangerously-skip-permissions'

# pi
pigpt55() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

  if [ -d "$root/.claude/skills" ]; then
    command pi --model azure-openai-responses/gpt-5.5 --skill "$root/.claude/skills" "$@"
  else
    command pi --model azure-openai-responses/gpt-5.5 "$@"
  fi
}

# Azure subscription switching
# IDs live in an untracked env file, see the variable names below
[[ -f ~/.config/az-subscriptions.env ]] && source ~/.config/az-subscriptions.env
alias az-emea-prod='az account set --subscription "$AZ_SUB_EMEA_PROD" && echo "Switched to EMEA Prod"'
alias az-amer-prod='az account set --subscription "$AZ_SUB_AMER_PROD" && echo "Switched to AMER Prod"'
alias az-amer-stage='az account set --subscription "$AZ_SUB_AMER_STAGE" && echo "Switched to AMER Staging"'
alias az-amer-dev='az account set --subscription "$AZ_SUB_AMER_DEV" && echo "Switched to AMER Dev"'

# Azure admin
alias az-login-admin='az login --tenant "$AZ_TENANT_ADMIN" --allow-no-subscriptions'
alias azlogin-admin='az login --tenant "$AZ_TENANT_ADMIN" --allow-no-subscriptions'
# Device code: WSL browser handoff is broken, complete the login in Windows Edge/Chrome InPrivate
alias az-login-admin-code='az login --tenant "$AZ_TENANT_ADMIN" --allow-no-subscriptions --use-device-code'
alias azlogin-admin-code='az login --tenant "$AZ_TENANT_ADMIN" --allow-no-subscriptions --use-device-code'
alias az-pim-status='az account get-access-token --resource https://management.azure.com >/dev/null 2>&1; az rest --method GET --url "https://management.azure.com/providers/Microsoft.Authorization/roleAssignmentScheduleInstances?\$filter=asTarget()&api-version=2020-10-01" --output json 2>/dev/null | python3 -c "
import json, sys
from datetime import datetime, timezone
data = json.load(sys.stdin)
now = datetime.now(timezone.utc)
for item in data.get(\"value\", []):
    p = item[\"properties\"]
    exp = p.get(\"expandedProperties\", {})
    role = exp.get(\"roleDefinition\", {}).get(\"displayName\", \"?\")
    scope = exp.get(\"scope\", {}).get(\"displayName\", \"?\")
    end = p.get(\"endDateTime\", \"\")
    if end:
        dt = datetime.fromisoformat(end.replace(\"Z\", \"+00:00\"))
        remaining = dt - now
        hrs, rem = divmod(int(remaining.total_seconds()), 3600)
        mins = rem // 60
        time_left = f\"{hrs}h{mins}m left\" if remaining.total_seconds() > 0 else \"EXPIRED\"
    else:
        time_left = \"no expiry\"
    if p.get(\"assignmentType\") == \"Activated\":
        user = exp.get(\"principal\", {}).get(\"displayName\", \"?\")
        print(f\"{user}: {role} on {scope} — {time_left}\")
"'
