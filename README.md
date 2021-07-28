## Requirements

Before installing the configuration file please be sure to install the following packages from the OS repository:

    - stow (required to create symlinks)
    - curl
    - ripgrep
    - universal-ctags
    - zsh
    - tmux
    - bat
    - exa
    - git
    - broot

### Zsh'z plugins

Plugins are managed by [antibody](http://getantibody.github.io/). To add a new
plugin modify the file zsh_plugins.txt and afterward run the function
`gen_plugins_file`, and reload the shell. and `gen_completions` to generate completions files.

## Install

To install simply run:

```
    git clone https://github.com/icyd/dotfiles ~/.dotfiles
    bash ~/.dotfiles/install.sh -light
```
