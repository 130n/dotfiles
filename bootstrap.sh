#!/usr/bin/env bash
########## Variables

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
# list of files/folders to symlink in homedir
files=".zshrc .vimrc .vim .aliases .exports .functions .oh-my-zsh/themes/agnoster-leon.zsh-theme .nvm_init .sbabrc"

##########

# create dotfiles_old in homedir
echo "Creating $olddir for backup of any existing dotfiles in ~"
mkdir -p $olddir
echo "...done"

# change to the dotfiles directory
echo "Changing to the $dir directory"
cd $dir
echo "...done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
	echo "Moving any existing dotfiles from ~ to $olddir"
	mv ~/$file $olddir/$file
	echo "Creating symlink to $file in home directory."
	ln -s $dir/$file ~/$file
done

mkdir -p ~/.vim/swaps
mkdir -p ~/.vim/backups
source ~/.zshrc
