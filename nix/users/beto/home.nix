args@{
  pkgs,
  lib,
  config,
  stateVersion,
  username,
  email,
  homeDirectory,
  nix-colors,
  ...
}:
let
  alacrittyFont =
    let
      fontname = "AnonymicePro Nerd Font";
    in
    {
      normal = {
        family = fontname;
      };
      size = 15;
    };
in
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "capitaine-cursors-white";
      enable-hot-corners = true;
      gtk-theme = "Arc-Dark";
      icon-theme = "Papirus-Dark";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [
        (mkTuple [
          "xkb"
          "icyd"
        ])
        (mkTuple [
          "xkb"
          "engrammer"
        ])
        (mkTuple [
          "xkb"
          "us"
        ])
      ];
      xkb-options = [
        "lv3:ralt_switch"
        "compose:102"
        "caps:swapescape"
        "shift:breaks_caps"
        "grp:alt_space_toggle"
      ];
    };
    "org/gnome/mutter" = {
      edge-tiling = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = 3700;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      search = [ "<Super>space" ];
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "Vitals@CoreCoding.com"
        "dash-to-panel@jderose9.github.com"
        "paperwm@paperwm.github.com"
        "trayIconsReloaded@selfmade.pl"
      ];
      favorite-apps = [
        "firefox.desktop"
        "org.wezfurlong.wezterm.desktop"
      ];
    };
    "org/gnome/shell/extensions/dash-to-panel" = {
      panel-positions = ''{"0":"TOP"}'';
      panel-sizes = ''{"0":32}'';
    };
    "system/locale" = {
      region = "es_ES.UTF-8";
    };
  };
  imports = [ (import ../../modules/home-common.nix (args // { inherit alacrittyFont; })) ];
  home.packages = with pkgs; [
    buildah
    calibre
    chromium
    discord
    dropbox
    gcc
    gcc-arm-embedded
    glibc
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.paperwm
    gnomeExtensions.tray-icons-reloaded
    kicad-small
    kind
    kubernetes
    kubernetes-helm
    libreoffice-fresh
    lutris
    openocd
    # unstable.quickemu
    # unstable.quickgui
    vscode-extensions.vadimcn.vscode-lldb
    winetricks
    wineWowPackages.waylandFull
  ];
  home.persistence."/mnt/containers" = {
    allowOther = false;
  };
  home.persistence."/mnt/vms" = {
    allowOther = false;
    directories = [
      ".containers"
      ".qemu"
      ".VirtualBox"
      "Games"
    ];
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
  programs.firefox = {
    enable = true;
    policies.SecurityDevices = {
      dnie-pkcs11 = "${(pkgs.callPackage ../../modules/dnie.nix { })}/usr/lib/libpkcs11-dnie.so";
    };
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
  programs.gpg = {
    enable = true;
    settings = {
      keyserver = "hkps://keys.openpgp.org";
    };
  };
  services = {
    gpg-agent = import ../../modules/services/gpg.nix { };
    lorri.enable = true;
    pueue = {
      enable = true;
      settings = {
        daemon = {
          default_parallel_tasks = 2;
        };
        shared = {
          use_unix_socket = true;
        };
      };
    };
  };
  systemd.user.services = {
    neovim-headless = {
      Service.Environment = "PATH=/run/current-system/sw/bin:${config.home.homeDirectory}/.nix-profile/bin";
      Service.ExecStart = ''${pkgs.zsh}/bin/zsh -c "${pkgs.neovim}/bin/nvim --headless --listen 127.0.0.1:9091"'';
      Service.Restart = "always";
      Service.RestartSec = 3;
      Service.Type = "simple";
      Unit.Description = "Neovim headless server";
      Unit.StartLimitBurst = 5;
      Unit.StartLimitIntervalSec = 300;

    };
    neovim-server =
      let
        dependencies = [
          "neovim-server.socket"
          "neovim-headless.service"
        ];
      in
      {
        Service.ExecStart = "/run/current-system/sw/lib/systemd/systemd-socket-proxyd --exit-idle-time 300 127.0.0.1:9091";
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
