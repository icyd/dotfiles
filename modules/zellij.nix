{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: {
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
      "zellij/layouts/default.kdl".text = with config.lib.stylix.colors.withHashtag; ''
        layout {
          default_tab_template {
            pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                format_left "{mode} #[fg=${base0C},bold]{session}"
                format_center "{tabs}"
                format_right "{command_git_branch} {datetime}"
                format_space ""

                hide_frame_for_single_pane "true"

                mode_normal        "#[fg=${base01},bg=${base0B}] {name} "
                mode_locked        "#[fg=${base01},bg=${base09}] {name} "
                mode_resize        "#[fg=${base01},bg=#DCA561] {name} "
                mode_pane          "#[fg=${base01},bg=${base0F}] {name} "
                mode_tab           "#[fg=${base01},bg=#938AA9] {name} "
                mode_scroll        "#[fg=${base01},bg=${base0E}] {name} "
                mode_enter_search  "#[fg=${base01},bg=#957FB8] {name} "
                mode_search        "#[fg=${base01},bg=#D27E99] {name} "
                mode_rename_tab    "#[fg=${base01},bg=#C8C093] {name} "
                mode_rename_pane   "#[fg=${base01},bg=#C8C093] {name} "
                mode_session       "#[fg=${base01},bg=#89B4FA] {name} "
                mode_move          "#[fg=${base01},bg=#DCA561] {name} "
                mode_prompt        "#[fg=${base01},bg=${base0A}] {name} "
                mode_tmux          "#[fg=${base01},bg=#DCD7BA] {name} "

                tab_normal   "#[fg=${base03}] {name} "
                tab_active   "#[fg=${base06},bold,italic] {name} "

                command_git_branch_command "git rev-parse --abbrev-ref HEAD"
                command_git_branch_format "#[fg=${base0D}] {stdout}"
                command_git_branch_interval "10"
                command_git_branch_rendermode "static"

                datetime "#[fg=${base03},bold] {format}"
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "Europe/Madrid"
              }
            }
            children
          }
        }
      '';
    };
  };
}
