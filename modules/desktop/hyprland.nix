topLevel: {
  nixpkgs.allowedUnfreePackages = [
    # For nvtop nvidia
    "cuda_cuobjdump"
    "cuda_cupti"
    "cuda_cuxxfilt"
    "cuda_gdb"
    "cuda-merged"
    "cuda_nvml_dev"
    "cuda_nvrtc"
    "cuda_nvdisasm"
    "cuda_nvprune"
    "cuda_nvtx"
    "cuda_profiler_api"
    "cuda_sanitizer_api"
    "libcufft"
    "libcurand"
    "libcusolver"
    "libnvjitlink"
    "libcusparse"
    "libnpp"
  ];
  flake.modules.nixos.hyprland = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      brightnessctl
      nvtopPackages.nvidia
    ];
    environment.sessionVariables = {
      # Ensure apps natively look for Wayland
      NIXOS_OZONE_WL = 1;
      # Use local VFS instead of GNOME's gvfs
      GIO_USE_VFS = "local";
      # Ensure proper Wayland backend
      GDK_BACKEND = "wayland,x11";
      # Ensure proper Wayland for Qt apps
      QT_QPA_PLATFORM = "wayland;xcb";
      WEBKIT_DISABLE_DMABUF_RENDERER = 1;
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    security.pam.services.hyprlock = {};
    services.displayManager.defaultSession = topLevel.lib.mkDefault "hyprland-uwsm";
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-hyprland];
      config = {
        common.default = ["gtk"];
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };
  };
  flake.modules.homeManager.hyprland = {
    lib,
    pkgs,
    ...
  }: let
    awww-wallch = pkgs.writeScriptBin "awww-wallch" ''
      #!/bin/sh
      WALLPAPER_DIR="''${WALLPAPER_DIR:-"$HOME/wallpaper"}"
      WALLPAPER="$(find "$WALLPAPER_DIR" -type f -name '*.jpg' -o -name '*.png' | shuf -n 1)"
      awww img "$WALLPAPER" --transition-type random
    '';

    rofipass = pkgs.writeScriptBin "rofipass" ''
      #!/bin/sh
      GOPASS="$(which gopass 2>/dev/null)"
      PASS="$("$GOPASS" list -f | rofi -i -dmenu 2>/dev/null)"
      [ -n "$PASS" ] && "$GOPASS" show -c "$PASS"
    '';
  in {
    home.packages = with pkgs; [
      alacritty
      rofipass
      grim
      slurp
      awww
      wdisplays
      wl-clipboard
      wlogout
    ];
    programs.hyprlock.enable = true;
    programs.rofi = {
      enable = true;
      cycle = true;
      # package = pkgs.rofi;
    };
    programs.wlogout.enable = true;
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
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
          # "hyprland/submap"
          # "hyprland/language"
          "custom/gpu-usage"
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
          on-scroll-up = "${lib.getExe pkgs.brightnessctl} --device=amdgpu_bl1 set +2%";
          on-scroll-down = "${lib.getExe pkgs.brightnessctl} --device=amdgpu_bl1 set 2%-";
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
          on-click = "wezterm start -- btop";
        };
        "custom/gpu-usage" = {
          exec = "${lib.getExe pkgs.gpu-usage-waybar}";
          return-type = "json";
          format-icons = "󰾲";
          format = "{} {icon}";
          on-click = "wezterm start -- nvtop";
        };
        # "hyprland/language" = {
        #   format = "{}";
        #   max-length = 18;
        # };
        # "hyprland/submap" = {
        #   format = "✌️ {}";
        #   max-length = 8;
        #   tooltip = false;
        # };
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
          # on-click = "activate";
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
          on-click = "wezterm start -- btop";
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
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
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
    services.clipman.enable = true;
    services.dunst.enable = true;
    services.kanshi = {
      enable = true;
      systemdTarget = "hyprland-session.target";
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
            on-timeout = "${lib.getExe pkgs.brightnessctl} --device=amdgpu_bl1 --save set 0";
            on-resume = "${lib.getExe pkgs.brightnessctl} --device=amdgpu_bl1 --restore";
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
    services.redshift = {
      enable = true;
      tray = true;
      latitude = 41.38;
      longitude = 2.16;
    };
    systemd.user = {
      sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      services = {
        awww-daemon = {
          Install.WantedBy = ["default.target"];
          Service.Environment = "RUST_BACKTRACE=1";
          Service.ExecStart = "${pkgs.awww}/bin/awww-daemon -f xrgb";
          Service.Restart = "on-failure";
          Service.RestartSec = 5;
          Unit.Description = "Start awww daemon";
          Unit.After = "hyprland-session.target";
          Unit.StartLimitBurst = 5;
          Unit.StartLimitIntervalSec = 300;
        };
        change-wallpaper = {
          Unit.Description = "Change wallpaper with awww";
          Service.ExecStart = "${awww-wallch}/bin/awww-wallch";
        };
      };
      timers = {
        change-wallpaper = {
          Install.WantedBy = ["timers.target"];
          Timer.OnCalendar = "hourly";
          Timer.OnStartupSec = "1h";
          Unit.Description = "Change wallpaper with awww every hour";
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      package = pkgs.hyprland;
      settings = let
        inherit (lib.generators) mkLuaInline toLua;
        mod = "SUPER";
        modShift = "SUPER + SHIFT";
        dirs = {
          left = "H";
          down = "J";
          up = "K";
          right = "L";
        };
        terminal = "wezterm";
        fileManager = "nautilus";
        menu = "rofi";
        browser = "firefox";
        clipmanager = "clipman pick -t ${menu}";
        dsp = name: args:
          mkLuaInline "hl.dsp.${name}(${
            if (args != {})
            then (toLua {} args)
            else ""
          })";
        bindOpts = key: dsp: opts: {_args = lib.filter (x: x != {}) [key dsp opts];};
        bind = key: dsp: bindOpts key dsp {};
      in {
        config = {
          binds = {
            allow_workspace_cycles = true;
            workspace_back_and_forth = true;
          };
          decoration = {
            rounding = 6;
            blur = {
              enabled = true;
              size = 8;
              passes = 2;
            };
          };
          input = {
            kb_layout = "us";
            kb_variant = "altgr-intl";
            kb_options = "lv3:ralt_switch, shift:breaks_caps";
            follow_mouse = 1;
            numlock_by_default = true;
            sensitivity = 0;
            touchpad.natural_scroll = false;
          };
        };
        monitor = [
          {
            output = "DVI-I-1";
            mode = "1920x1080@144";
            position = "0x0";
            scale = 1;
          }
          {
            output = "eDP-1";
            mode = "1920x1080@144";
            position = "1920x0";
            scale = 1;
          }
        ];
        bind = lib.flatten [
          (bind "${mod} + Return" (dsp "exec_cmd" terminal))
          (bind "${mod} + Space" (dsp "exec_cmd" "${menu} -show drun -show-icons"))
          (bind "${modShift} + Q" (dsp "window.close" {}))
          (bind "${modShift} + E" (dsp "exit" {}))
          (bind "${modShift} + P" (dsp "exec_cmd" "wlogout"))
          (bind "${mod} + F" (dsp "exec_cmd" fileManager))
          (bind "${mod} + B" (dsp "exec_cmd" browser))
          (bind "${mod} + X" (dsp "exec_cmd" clipmanager))
          (bind "${mod} + CONTROL + B" (dsp "exec_cmd" "rofipass"))
          (bind "${mod} + Z" (dsp "window.fullscreen" {mode = "fullscreen";}))
          (bind "${modShift} + Z" (dsp "window.fullscreen" {mode = "maximized";}))
          (bind "${mod} + V" (dsp "window.float" {action = "toggle";}))
          (bind "${modShift} + V" (dsp "window.float" {action = "set";}))
          (bind "${mod} + P" (dsp "window.pseudo" {action = "toggle";}))
          (bind "${modShift} + R" (dsp "force_renderer_reload" {}))
          (bind "${modShift} + T" (dsp "layout" "togglesplit"))
          (bind "${mod} + S" (dsp "workspace.toggle_special" "magic"))
          (bind "${modShift} + S" (dsp "window.move" {workspace = "special:magic";}))
          (bind "${mod} + Tab" (dsp "focus" {workspace = "e+1";}))
          (bind "${modShift} + Tab" (dsp "window.move" {monitor = "+1";}))
          (
            lib.mapAttrsToList (direction: key: [
              (bind "${mod} + ${key}" (dsp "focus" {inherit direction;}))
              (bind "${modShift} + ${key}" (dsp "window.move" {inherit direction;}))
            ])
            dirs
          )
          (
            map (workspace: [
              (bind "${mod} + ${workspace}" (dsp "focus" {inherit workspace;}))
              (bind "${modShift} + ${workspace}" (dsp "window.move" {inherit workspace;}))
            ]) (map (x: toString (lib.mod x 10)) (lib.range 1 10))
          )
          (bind "${mod} + mouse_up" (dsp "focus" {workspace = "e+1";}))
          (bind "${mod} + mouse_down" (dsp "focus" {workspace = "e-1";}))
          (bind "${modShift} + mouse_up" (dsp "window.move" {monitor = "+1";}))
          (bind "${modShift} + mouse_down" (dsp "window.move" {monitor = "-1";}))
          (bind "Print" (dsp "exec_cmd" ''grim -g "$(slurp -d)" - | wl-copy''))
          (bindOpts "${mod} + mouse:272" (dsp "window.drag" {}) {mouse = true;})
          (bindOpts "${mod} + mouse:273" (dsp "window.resize" {}) {mouse = true;})
          (bindOpts "XF86AudioRaiseVolume" (dsp "exec_cmd" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioLowerVolume" (dsp "exec_cmd" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioMute" (dsp "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioMicMute" (dsp "exec_cmd" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86MonBrightnessUp" (dsp "exec_cmd" "brightnessctl --device=amdgpu_bl1 set +5%") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86MonBrightnessDown" (dsp "exec_cmd" "brightnessctl --device=amdgpu_bl1 set 5%-") {
            locked = true;
            repeating = true;
          })
          (bindOpts "XF86AudioNext" (dsp "exec_cmd" "playerctl next") {
            locked = true;
          })
          (bindOpts "XF86AudioPrev" (dsp "exec_cmd" "playerctl previous") {
            locked = true;
          })
          (bindOpts "XF86AudioPlay" (dsp "exec_cmd" "playerctl play-pause") {
            locked = true;
          })
        ];
        on._args = [
          "hyprland.start"
          (mkLuaInline
            ''
              function()
                hl.exec_cmd("nm-applet --indicator")
                hl.exec_cmd("dbus-update-activation-environment --systemd --all WEBKIT_DISABLE_DMABUF_RENDERER=1")
                hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")
                hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk")
                hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland xdg-desktop-portal-gtk")
                hl.exec_cmd("systemctl --user start xdg-desktop-portal")
              end
            '')
        ];
        env = [
          {
            _args = [
              "WEBKIT_DISABLE_DMABUF_RENDERER"
              "1"
            ];
          }
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
      #       gesture_distance = 300
      #       gesture_positive = false
      #     }
      #   }
      # '';
    };
  };
}
