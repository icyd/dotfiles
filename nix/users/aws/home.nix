{ config, pkgs, lib, nix-colors, email, ... }:
let
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    mypkgs = with pkgs; [
      binutils
      cmake
      ccls
      gcc
      gdb
      vifm
    ];
in (import ../../modules/home-common.nix { inherit config pkgs lib nix-colors email; }) //
{
    programs.bat = {
        enable = true;
        config = { theme = "base16"; };
    };
    programs.broot.enable = true;
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.home-manager.enable = true;
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs; };
}
