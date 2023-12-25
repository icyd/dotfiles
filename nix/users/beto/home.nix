args@{ pkgs, lib, config, stateVersion, username, email, homeDirectory
, nix-colors, ... }:
let
  alacrittyFont = let fontname = "AnonymicePro Nerd Font";
  in {
    normal = { family = fontname; };
    size = 15;
  };
in {
  imports = [
    (import ../../modules/home-common.nix (args // { inherit alacrittyFont; }))
  ];
  home.packages = with pkgs; [
    chromium
    discord
    gcc
    gcc-arm-embedded
    glibc
    kicad-small
    libreoffice-fresh
    lutris
    openocd
    winetricks
    wineWowPackages.waylandFull
  ];
  home.persistence."/mnt/lutris" = {
    allowOther = false;
    directories = [ "Games" ];
  };
  home.persistence."/mnt/win10/Users/${username}" = {
    allowOther = false;
    directories = [ "Downloads" "Documents" "Pictures" "Videos" ];
  };
  home.persistence."/persist/home/${username}" = {
    allowOther = false;
    directories = [
      {
        directory = ".dotfiles";
        method = "symlink";
      }
      ".local/share/gopass"
      "Backups"
      "Calibre Library"
      "Desktop"
      "Projects"
      "scripts"
    ];
    files = [ ".wallpaper.jpg" ".zsh_history" ];
  };
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with pkgs; [
        nur.repos.rycee.firefox-addons.gopass-bridge
        nur.repos.rycee.firefox-addons.vimium
      ];
      settings = {
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
  programs.gpg.enable = true;
  services = {
    gpg-agent =
      import ../../modules/services/gpg.nix { pinentryFlavor = "gnome3"; };
    lorri.enable = true;
    pueue = {
      enable = true;
      settings = {
        daemon = { default_parallel_tasks = 2; };
        shared = { use_unix_socket = true; };
      };
    };
  };
  systemd.user.services = {
    neovim-headless = {
      Service.Environment =
        "PATH=/run/current-system/sw/bin:${config.home.homeDirectory}/.nix-profile/bin";
      Service.ExecStart = ''
        ${pkgs.zsh}/bin/zsh -c "${pkgs.neovim-nightly}/bin/nvim --headless --listen 127.0.0.1:9091"'';
      Service.Restart = "always";
      Service.RestartSec = 3;
      Service.Type = "simple";
      Unit.Description = "Neovim headless server";
      Unit.StartLimitBurst = 5;
      Unit.StartLimitIntervalSec = 300;

    };
    neovim-server =
      let dependencies = [ "neovim-server.socket" "neovim-headless.service" ];
      in {
        Service.ExecStart =
          "/run/current-system/sw/lib/systemd/systemd-socket-proxyd --exit-idle-time 300 127.0.0.1:9091";
        Service.Type = "notify";
        Unit.After = dependencies;
        Unit.Description = "Neovim socket activation proxyd";
        Unit.Requires = dependencies;
      };
  };
  systemd.user.sockets = {
    neovim-server = {
      Install.WantedBy = [ "sockets.target" ];
      Socket.BindIPv6Only = "both";
      Socket.ListenStream = 9090;
      Unit.Description = "Neovim headless server socket";
    };
  };
  xdg.configFile = {
    gammastep.source = ../../../sway/gammastep;
    mako.source = ../../../sway/mako;
    sway.source = ../../../sway/sway;
    swaylock.source = ../../../sway/swaylock;
    waybar.source = ../../../sway/waybar;
    wlogout.source = ../../../sway/wlogout;
    wofi.source = ../../../sway/wofi;
    xkb.source = ../../../xkb;
  };
}
