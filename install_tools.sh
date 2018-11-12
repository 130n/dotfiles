cd ~
#ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

#homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew cask install java
brew install thefuck archey fpp node tpp wget git htop-osx sl zsh prettyping maven

gem install bropages
curl -sLf https://spacevim.org/install.sh | bash

#nvm
mkdir .nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/creationix/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin`
) && . "$NVM_DIR/nvm.sh"
npm install npm -g

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts && ./install.sh
# clean-up a bit
cd .. && rm -rf fonts

#mkdir -p ~/.vim/autoload ~/.vim/bundle && \
#	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
