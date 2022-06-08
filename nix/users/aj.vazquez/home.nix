{ config, pkgs, lib, nix-colors, email, ... }:
let
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    mypkgs = with pkgs; [
      reattach-to-user-namespace
    ];
    mypaths = [
        "/opt/homebrew/bin"
    ];
in (import ../../modules/home-common.nix { inherit config pkgs lib nix-colors email mypkgs mypaths; }) // {
    xdg.configFile = {
        nvim.source = config.lib.file.mkOutOfStoreSymlink "${DOTFILES}/nvim";
    };
    programs.alacritty = import ../../modules/alacritty.nix { inherit config; };
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
    xdg.configFile = {
        tmuxp.source = ../../../tmux/tmuxp;
    };
}
