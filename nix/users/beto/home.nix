{ config, pkgs, lib, nix-colors, email, ... }:
let
    DOTFILES = "${config.home.homeDirectory}/.dotfiles";
    mypkgs = with pkgs; [
      binutils
      cargo
      cmake
      chromium
      ccls
      dive
      docker
      (pkgs.callPackage ../../modules/go/gig/default.nix {})
      gcc
      gcc-arm-embedded
      gdb
      glibc
      go_1_18
      gopass
      gopass-jsonapi
      luajit
      luajitPackages.luarocks
      kicad-small
      libreoffice-fresh
      mosh
      openocd
      rustc
      rust-analyzer
      sshfs
      sumneko-lua-language-server
      vifm
    ];
in (import ../../modules/home-common.nix { inherit config pkgs lib nix-colors email mypkgs; }) //
{
    programs.firefox = {
        enable = true;
        profiles.default = {
            settings = {
                "media.ffmpeg.vaapi.enabled" = true;
            };
        };
        extensions = with pkgs; [
            nur.repos.rycee.firefox-addons.vimium
            nur.repos.rycee.firefox-addons.gopass-bridge
        ];
    };
    programs.alacritty = import ../../modules/alacritty.nix { inherit config; };
    programs.bat = {
        enable = true;
        config = { theme = "base16"; };
    };
    programs.broot.enable = true;
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.gpg.enable = true;
    programs.home-manager.enable = true;
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs; };
    services = {
        gpg-agent = import ../../modules/services/gpg.nix { pinentryFlavor = "gnome3"; };
        lorri.enable = true;
    };
    xdg.configFile = {
        gammastep.source = ../../../sway/gammastep;
        mako.source = ../../../sway/mako;
        nvim.source = config.lib.file.mkOutOfStoreSymlink "${DOTFILES}/nvim";
        sway.source = ../../../sway/sway;
        swaylock.source = ../../../sway/swaylock;
        waybar.source = ../../../sway/waybar;
        wlogout.source = ../../../sway/wlogout;
        wofi.source = ../../../sway/wofi;
        tmuxp.source = ../../../tmux/tmuxp;
        xkb.source = ../../../xkb;
    };
}
