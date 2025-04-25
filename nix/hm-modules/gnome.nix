{
  lib,
  pkgs,
  ...
}: {
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      # cursor-theme = "capitaine-cursors-white";
      enable-hot-corners = true;
      # gtk-theme = "Arc-Dark";
      # icon-theme = "Papirus-Dark";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [
        (mkTuple [
          "xkb"
          "icydenthium"
        ])
        # (mkTuple [
        #   "xkb"
        #   "us+altgr-intl"
        # ])
      ];
      xkb-options = [
        "lv3:ralt_switch"
        "compose:102"
        # "caps:swapescape"
        "caps:escape_shifted_capslock"
        "shift:breaks_caps"
        # "grp:alt_space_toggle"
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
      search = ["<Super>space"];
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
  };
  home.packages = with pkgs; [
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.paperwm
    gnomeExtensions.tray-icons-reloaded
  ];
}
