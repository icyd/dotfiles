{
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  imports = [
    ../../hm-modules/alacritty.nix
    ../../hm-modules/gnome.nix
    ../../hm-modules/firefox.nix
    ../../hm-modules/home.nix
    ../../hm-modules/hyprland.nix
    ../../hm-modules/neovim-server.nix
    # ../../hm-modules/zellij.nix
  ];
  my.services.neovim-server = {
    enable = true;
    package = pkgs.nixvim;
  };
  home.packages = with pkgs; [
    calibre
    celluloid
    chromium
    discord
    dropbox
    gcc
    gcc-arm-embedded
    glibc
    haruna
    kicad-unstable-small
    libreoffice-fresh
    lutris
    minikube
    nixvim
    docker-machine-kvm2
    openocd
    synapse
    winetricks
    wineWowPackages.waylandFull
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
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };
  # my = {
  #   zellij = {
  #     configFile = ../../zellij/config.kdl;
  #     settings = {
  #       copy_on_select = true;
  #       default_shell = "nu";
  #       pane_frames = false;
  #       simplified_ui = true;
  #       theme = "stylix";
  #     };
  #   };
  # };
  programs.alacritty = {
    settings.terminal.shell = with config.programs; {
      program = "${zsh.package}/bin/zsh";
      args = [
        "-c"
        "${nushell.package}/bin/nu"
      ];
    };
  };
  programs.gpg = {
    enable = true;
    settings.keyserver = "hkps://keys.openpgp.org";
  };
  programs.git.userEmail = "beto.v25@gmail.com";
  services = {
    pueue = {
      enable = true;
      settings = {
        daemon.default_parallel_tasks = 2;
        shared.use_unix_socket = true;
      };
    };
  };
  stylix = {
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    targets.firefox.profileNames = [
      "default"
    ];
  };
  xdg.configFile = {
    gammastep.source = ../../../sway/gammastep;
    mako.source = ../../../sway/mako;
    sway.source = ../../../sway/sway;
    swaylock.source = ../../../sway/swaylock;
    # waybar.source = ../../../sway/waybar;
    # wlogout.source = ../../../sway/wlogout;
    # wofi.source = ../../../sway/wofi;
  };
}
