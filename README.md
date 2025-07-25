# Nixos and home-manager flake configuration

Repository with Nix's flake system configurations, based on [dendritic
pattern](https://github.com/mightyiam/dendritic) and [flake-parts](https://flake.parts/).
Modules are imported using [import-tree](https://github.com/vic/import-tree), in order to exclude a module or configuration, prepend the file with a `_`.

File systems is defined as code using [disko](https://github.com/nix-community/disko).

**Note:** `home-manager` is manage as
[standalone](https://nix-community.github.io/home-manager/index.xhtml#sec-install-standalone).

## Usage

```bash
    sudo nix run github:nix-community/disko -- --mode destroy,format,mount
    modules/hosts/<hostname>/_disko.nix

    sudo nixos-install --flake github:icyd/dotfiles#<hostname>

```
