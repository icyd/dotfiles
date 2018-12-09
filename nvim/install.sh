#!/bin/bash
#Creating directories and copy configuration files
mkdir -p ~/.config/nvim
cp -f init.vim ~/.config/nvim
cp -f ginit.vim ~/.config/nvim
cp -rf config ~/.config/nvim/

#Installing vim-plug
mkdir -p ~/.config/nvim/plugged

if [ ! -f "$HOME/config/nvim/autoload/plug.vim" ]; then
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

sed '/^\s*call\splug\#end\(\)/q' "config/plugins.vimrc" > /tmp/tmp.vimrc
nvim -u /tmp/tmp.vimrc -c 'PlugInstall! | qa!'

if [ ! -f "$HOME/.config/nvim/thesaurus/mthesaur.txt" ]; then
	mkdir -p ~/.config/nvim/thesaurus
	curl -fLo ~/.config/nvim/thesaurus/mthesaur.txt --create-dirs \
            http://www.gutenberg.org/files/3202/files/mthesaur.txt
fi

mkdir -p ~/.bin
