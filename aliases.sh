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


