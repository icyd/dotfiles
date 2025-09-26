{lib, ...}: {
  flake.modules.homeManager.base = {pkgs, ...}: {
    programs.zellij.enable = true;
    xdg.configFile = {
      "zellij/config.kdl".text =
        [
          (builtins.readFile ../config/zellij/config.kdl)
          ''

            plugins {
              autolock location="file:${lib.getExe pkgs.local.zellij-autolock}" {
                is_enabled true
                triggers "nvim|vim|git|fzf|zoxide"
              }
            }

            load_plugins {
              autolock
            }
          ''
        ]
        |> lib.mkMerge;
      "zellij/layouts/default.kdl".text = ''
        layout {
          default_tab_template {
            children
            pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                format_left "{mode} {session}"
                format_center "{tabs}"
                format_right "{datetime}"
                hide_frame_for_single_pane "true"
                datetime "{format}"
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "Europe/Madrid"
              }
            }
          }
        }

      '';
    };
  };
}
