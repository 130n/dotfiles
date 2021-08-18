cd ~
#ohmyzsh
#sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

#homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update
brew cask install java
brew install fpp node tpp wget git htop-osx sl zsh prettyping maven

gem install bropages
curl -sLf https://spacevim.org/install.sh | bash

#nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
nvm install node

# powerline fonts
cd $HOME
git clone --depth=1 https://github.com/powerline/fonts.git
# install
cd fonts && ./install.sh
# clean-up a bit
cd .. && rm -rf fonts

#mkdir -p ~/.vim/autoload ~/.vim/bundle && \
#	curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
