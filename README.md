## Requirements

Before installing the configuration file please be sure to install the following packages from the OS repository:

    - ripgrep
    - python3
    - universal-ctags
    - zsh
    - tmux
    - ccls or clang
    - Eclipse JDT Language Server
    - gopls
    - bat
    - exa
    - node && npm
    - git
    - neofetch
    - starship
    - broot

Also check <https://github.com/pyenv/pyenv/wiki/Common-build-problems> for requirements to install pyenv.

### Zsh'z plugins

Plugins are managed by [antibody](http://getantibody.github.io/). To add a new
plugin modify the file zsh_plugins.txt and afterward run the function
`gen_plugins_file`, and reload the shell.

## Configurations

This repository have personal configuration for the following applications:

    - mako
    - mpd
    - neomutt
    - neovim
    - qutebrowser
    - sway
    - tmux
    - vifm
    - zsh

### Neovim's python support

The Python 3 support is the only one enabled, requires a virtualenv where all
the supporting software for neovim is installed. Both python and node.js
packages. When new software is requiered, activate the pyenv-virtualenv first
and then run:

```
    pyenv activate foobar
    pip install ...
    npm -g install ...
    pyenv deactivate
```

Also there is an alias defined in zshrc where **nvim** is replaced by
neovim-remote, which avoid recursive opening of nvim inside its terminals.

## Install

To install simply run:

```
    cd ~/.config
    git clone https://github.com/icyd/dotfiles
    bash dotfiles/install.sh -all
```

To install a lightweight version for server managent, also replacing neovim with vim, and bash instead of zsh.

```
    bash dotfiles/install.sh -sv -all
```

## Minimalistic install for server

In order to install the dotfiles in a server, the environment variable **SERVER** should be set. This only install the configuration for:

    - bash
    - tmux
    - vim
