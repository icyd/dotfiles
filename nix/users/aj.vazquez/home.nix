{ config, pkgs, lib, nix-colors, email, ... }:
let
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    mypkgs = with pkgs; [
      dive
      (pkgs.callPackage ../../modules/go/gig/default.nix {})
      faas-cli
      go_1_17
      gopass
      gopass-jsonapi
      luajit
      luajitPackages.luarocks
      kind
      nodejs
      helmfile
      mosh
      rustup
      rust-analyzer
      reattach-to-user-namespace
      wget
    ];
    mypaths = [
        "/opt/homebrew/bin"
    ];
    sessionVars = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
    };
in (import ../../modules/home-common.nix { inherit config pkgs lib nix-colors email mypkgs mypaths sessionVars; }) // {
    programs.alacritty = import ../../modules/alacritty.nix { inherit config; startup_mode = "Fullscreen"; };
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
        nvim.source = config.lib.file.mkOutOfStoreSymlink "${DOTFILES}/nvim";
        tmuxp.source = ../../../tmux/tmuxp;
    };
}
