{pkgs, ...}: let
  swww-wallch = pkgs.writeScriptBin "swww-wallch" ''
    #!/bin/sh
    WALLPAPER_DIR="''${WALLPAPER_DIR:-"$HOME/wallpaper"}"
    WALLPAPER="$(find "$WALLPAPER_DIR" -type f -name '*.jpg' -o -name '*.png' | shuf -n 1)"
    swww img "$WALLPAPER" --transition-type random
  '';

  rofipass = pkgs.writeScriptBin "rofipass" ''
    #!/bin/sh
    GOPASS="$(which gopass 2>/dev/null)"
    PASS="$("$GOPASS" list -f | rofi -i -dmenu 2>/dev/null)"
    [ -n "$PASS" ] && "$GOPASS" show -c "$PASS"
  '';
in {
  home.packages = with pkgs; [
    rofipass
    grim
    slurp
    swww
    unstable.wezterm
    wl-clipboard
  ];
  programs.hyprlock.enable = true;
  programs.rofi = {
    enable = true;
    cycle = true;
    package = pkgs.rofi-wayland;
  };
  programs.waybar = {
    enable = true;
    package = (
      pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      })
    );
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 2;
      modules-left = [
        "hyprland/workspaces"
        "idle_inhibitor"
        "backlight"
        "pulseaudio"
        "network"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
        "hyprland/submap"
        "hyprland/language"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "tray"
        "clock#time"
        "clock#date"
      ];
      backlight = {
        format = "{icon}  {percent}%";
        on-scroll-up = "light -A 2";
        on-scroll-down = "light -U 2";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
          ""
        ];
      };
      battery = {
        interval = 10;
        states = {
          good = 75;
          warning = 25;
          critical = 15;
        };
        format = "  {icon}  {capacity}%";
        format-discharging = "{icon}  {capacity}%";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        tooltip = true;
      };
      "clock#time" = {
        interval = 1;
        format = "{:%H:%M}";
        tooltip = false;
      };
      "clock#date" = {
        interval = 10;
        format = "   {:%d/%m/%y}";
        tooltip-format = "{:%A %e %B %Y}";
      };
      cpu = {
        interval = 2;
        format = "{icon}";
        rotate = 270;
        states = {
          warning = 70;
          critical = 90;
        };
        format-icons = [
          "󰝦"
          "󰪞"
          "󰪟"
          "󰪠"
          "󰪡"
          "󰪢"
          "󰪣"
          "󰪤"
          "󰪥"
        ];
      };
      "hyprland/language" = {
        format = "{}";
        max-length = 18;
      };
      "hyprland/submap" = {
        format = "✌️ {}";
        max-length = 8;
        tooltip = false;
      };
      "hyprland/window" = {
        max-length = 50;
        separate-outputs = true;
      };
      "hyprland/workspaces" = {
        format = "{icon}  {name}";
        format-icons = rec {
          urgent = "";
          active = "";
          default = "";
          persistent = "";
          special = persistent;
        };
      };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = " ";
          deactivated = " ";
        };
      };
      memory = {
        interval = 5;
        rotate = 270;
        format = "{icon}";
        states = {
          warning = 70;
          critical = 90;
        };
        format-icons = [
          "󰝦"
          "󰪞"
          "󰪟"
          "󰪠"
          "󰪡"
          "󰪢"
          "󰪣"
          "󰪤"
          "󰪥"
        ];
        max-length = 10;
      };
      network = {
        interval = 3;
        # on-click = "networkmanager_dmenu",
        format-wifi = "   {essid}";
        format-ethernet = "  {ipaddr}/{cidr}";
        format-linked = "  {ifname} (No IP)";
        format-disconnected = "⚠   Disconnected";
        tooltip-format = "Network: <big><b>{essid}</b></big>\nSignal strength: <b>{signaldBm}dBm ({signalStrength}%)</b>\nFrequency: <b>{frequency}MHz</b>\nInterface: <b>{ifname}</b>\nIP: <b>{ipaddr}/{cidr}</b>\nGateway: <b>{gwaddr}</b>\nNetmask: <b>{netmask}</b>";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        scroll-step = 2;
        format = "{icon}  {volume}%";
        format-muted = "";
        format-icons = {
          headphones = "";
          handsfree = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
          ];
        };
        on-click = "wpclt set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pavucontrol";
        tooltip = true;
      };
      temperature = {
        critical-threshold = 75;
        interval = 5;
        format = "{icon}  {temperatureC}°C";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
        tooltip = true;
      };
      tray.spacing = 10;
    };
    systemd.enable = true;
  };
  programs.wlogout.enable = true;
  services.clipman.enable = true;
  services.dunst.enable = true;
  services.redshift = {
    enable = true;
    tray = true;
    latitude = 41.38;
    longitude = 2.16;
  };
  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              scale = 1.5;
              status = "enable";
            }
            {
              criteria = "eDP-2";
              scale = 1.0;
              status = "enable";
            }
          ];
        };
      }
    ];
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "hyprlock";
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "light -S 10 -O";
          on-resume = "light -I";
        }
        {
          timeout = 150;
          on-timeout = "light -s sysfs/leds/platform::kbd_backlight -S 0 -O";
          on-resume = "light -s sysfs/leds/platform::kbd_backlight -I";
        }
        {
          timeout = 300;
          on-timeout = "hyprlock";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  services.playerctld.enable = true;
  systemd.user = {
    services = {
      swww-daemon = {
        Install.WantedBy = ["default.target"];
        Service.Environment = "RUST_BACKTRACE=1";
        Service.ExecStart = "${pkgs.swww}/bin/swww-daemon -f xrgb";
        Service.Restart = "on-failure";
        Service.RestartSec = 5;
        Unit.Description = "Start swww daemon";
        Unit.After = "hyprland-session.target";
        Unit.StartLimitBurst = 5;
        Unit.StartLimitIntervalSec = 300;
      };
      change-wallpaper = {
        Unit.Description = "Change wallpaper with swww";
        Service.ExecStart = "${swww-wallch}/bin/swww-wallch";
      };
    };
    timers = {
      change-wallpaper = {
        Install.WantedBy = ["timers.target"];
        Timer.OnCalendar = "hourly";
        Timer.OnStartupSec = "1h";
        Unit.Description = "Change wallpaper with swww every hour";
      };
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = pkgs.hyprland;
    # plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
    #   # borders-plus-plus
    #   # hyprbars
    #   # hyprexpo
    # ];
    settings = {
      decoration = {
        rounding = 6;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };
      monitor = [
        "eDP-2, 1920x1080@144, 0x0, 1"
        ", preferred, auto, 1"
      ];
      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        # kb_options = "lv3:ralt_switch, compose:102, caps:swapescape, shift:breaks_caps, grp:alt_space_toggle";
        kb_options = "lv3:ralt_switch, shift:breaks_caps";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };
      device = [
        {
          name = "keebio-iris-rev.-6b";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = "lv3:ralt_switch, grp:alt_space_toggle";
        }
      ];
      "$mod" = "SUPER";
      "$modShift" = "SUPER_SHIFT";
      "$left" = "H";
      "$down" = "J";
      "$up" = "K";
      "$right" = "L";
      "$terminal" = "wezterm";
      "$fileManager" = "nautilus";
      "$menu" = "rofi";
      "$browser" = "firefox";
      "$clipmanager" = "clipman pick -t $menu";
      bind =
        [
          "$mod, Return, exec, $terminal"
          "$modShift, Q, killactive,"
          "$modShift, E, exit,"
          "$modShift, P, exec, wlogout"
          # "$mod, W, hyprexpo:expo, toggle"
          "$mod, F, exec, $fileManager"
          "$mod, B, exec, $browser"
          "$mod, V, togglefloating,"
          "$mod, Space, exec, $menu -show drun -show-icons"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"
          "$mod, Z, fullscreen,"
          "$mod, X, exec, $clipmanager"
          "$mod CONTROL, B, exec, rofipass"
          "$modShift, C, forcerendererreload,"
          "$mod, $left, movefocus, l"
          "$mod, $right, movefocus, r"
          "$mod, $up, movefocus, u"
          "$mod, $down, movefocus, d"
          "$modShift, $left, movewindow, l"
          "$modShift, $right, movewindow, r"
          "$modShift, $up, movewindow, u"
          "$modShift, $down, movewindow, d"
          "$mod, Tab, workspace, e+1"
          "$modShift, Tab, workspace, e-1"
          "$mod, S, togglespecialworkspace, magic"
          "$modShift, S, movetoworkspace, special:magic"
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          '', Print, exec, grim -g "$(slurp -d)" - | wl-copy''
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i: let
              ws =
                if i == 0
                then 10
                else i;
            in [
              "$mod, ${toString i}, workspace, ${toString ws}"
              "$modShift, ${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          10
        ));
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, light -A 2"
        ",XF86MonBrightnessDown, exec, light -U 2"
      ];
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "nm-applet --indicator &"
      ];
    };
    # extraConfig = with config.lib.stylix.colors; ''
    #   plugin {
    #     borders-plus-plus {
    #       add_borders = 1
    #       col.border_1 = rgb(${base00})
    #       col.border_2 = rgb(${base07})
    #       border_size_1 = 5
    #       border_size_2 = 5
    #     }
    #
    #     hyprbars {
    #       bar_height = 16
    #       bar_text_size = 10
    #       bar_padding = 12
    #       bar_button_padding = 10
    #       bar_precedence_over_border = true
    #
    #       hyprbars-button = rgb(${base08}), 10, , hyprctl dispatch killactive
    #       hyprbars-button = rgb(${base0A}), 10, , hyprctl dispatch fullscreen 2
    #       hyprbars-button = rgb(${base0B}), 10, , hyprctl dispatch togglefloating
    #     }
    #
    #     hyprexpo {
    #       columns = 2
    #       gap_size = 10
    #       workspace_method = center current
    #       enable_gesture = true
    #       gesture_fingers = 3
    #       gesture_distange = 300
    #       gesture_positive = false
    #     }
    #   }
    # '';
  };
}
