{ config, pkgs, lib, email, ... }:
let
    HOME = config.home.homeDirectory;
    DOTFILES = "${HOME}/.dotfiles";
in {
    fonts.fontconfig.enable = true;
    home = import ../../modules/home.nix { inherit config pkgs; };
    programs.alacritty = import ../../modules/alacritty.nix {};
    programs.bat = {
        enable = true;
        config = {
            theme = "base16";
        };
    };
    programs.broot.enable = true;
    programs.firefox = {
        enable = true;
        profiles.default = {
            settings = {
                "media.ffmpeg.vaapi.enabled" = true;
            };
        };
        extensions = with pkgs; [
            nur.repos.rycee.firefox-addons.vimium
        ];
    };
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.gpg.enable = true;
    programs.home-manager.enable = true;
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs; };
    services = {
        gpg-agent = import ../../modules/services/gpg.nix { pinentryFlavor = "gtk2"; };
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
        xkb.source = ../../../xkb;
    };
}
