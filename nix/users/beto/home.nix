{
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../hm-modules/gnome.nix
    ../../hm-modules/firefox.nix
    ../../hm-modules/home.nix
    ../../hm-modules/neovim-server.nix
  ];
  services.neovim-server.enable = true;
  home.packages = with pkgs; [
    calibre
    celluloid
    chromium
    discord
    dropbox
    gcc
    gcc-arm-embedded
    glibc
    kicad-small
    libreoffice-fresh
    lutris
    openocd
    synapse
    winetricks
    wineWowPackages.waylandFull
    zathura
  ];
  home.persistence."/mnt/nodatacow" = {
    allowOther = false;
    directories = [
      ".qemu"
      ".wine"
      "VirtualBox VMs"
      "Games"
    ];
  };
  home.persistence."/persist/home/${username}" = {
    allowOther = false;
    directories = [
      "Backups"
      "Calibre Library"
      "Desktop"
      "Documents"
      "Downloads"
      "Movies"
      "Pictures"
      "Projects"
      "scripts"
      "Videos"
    ];
    files = [
      ".wallpaper.jpg"
      ".zsh_history"
    ];
  };
  home.stateVersion = "22.05";
  home.sessionVariables = {
    NVIM_SERVER = lib.mkForce "::1:9090";
  };
  programs.gpg = {
    enable = true;
    settings.keyserver = "hkps://keys.openpgp.org";
  };
  services = {
    pueue = {
      enable = true;
      settings = {
        daemon.default_parallel_tasks = 2;
        shared.use_unix_socket = true;
      };
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
  };
}
