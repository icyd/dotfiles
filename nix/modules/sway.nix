{pkgs, ...}: let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in {
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      acpi
      alacritty
      brightnessctl
      dbus-sway-environment
      dracula-theme # gtk theme
      gammastep
      grim
      haruna
      kanshi
      mako
      slurp
      swayidle
      swaylock
      wlogout
      wdisplays
    ];
    extraOptions = ["--unsupported-gpu"];
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DISABLE_RDD_SANDBOX=1
      export WLR_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"
    '';
    wrapperFeatures.gtk = true;
  };
  security.pam.services.swaylock = {};
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      ExecStart = "${pkgs.kanshi}/bin/kanshi -c kanshi_config_file";
      Type = "simple";
    };
  };
}
