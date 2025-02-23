{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.zellij;
  yamlFormat = pkgs.formats.yaml {};
in {
  options.my.zellij = {
    settings = mkOption {
      type = yamlFormat.type;
      default = {};
      description = "Options for Zellij's configuration";
    };
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to Zellij configuration file";
    };
  };
  config = {
    programs.zellij.enable = true;
    xdg.configFile."zellij/config.kdl" = mkIf (cfg.settings != {} || cfg.configFile != null) {
      text = mkMerge [
        (mkIf (cfg.configFile != null) (builtins.readFile cfg.configFile))
        (mkIf (cfg.settings != {}) (lib.hm.generators.toKDL {} cfg.settings))
      ];
    };
    xdg.configFile."zellij/layouts/default.kdl".text = with config.lib.stylix.colors.withHashtag; ''
      layout {
          default_tab_template {
              pane size=2 borderless=true {
                  plugin location="file://${pkgs.zjstatus}/bin/zjstatus.wasm" {
                      format_left   "{mode}#[bg=${base00}] {tabs}"
                      format_center ""
                      format_right  "#[bg=${base00},fg=${base0D}]#[bg=${base0D},fg=${base01},bold] #[bg=${base02},fg=${base05},bold] {session} #[bg=${base03},fg=${base05},bold]"
                      format_space  ""
                      format_hide_on_overlength "true"
                      format_precedence "crl"

                      border_enabled  "false"
                      border_char     "─"
                      border_format   "#[fg=#6C7086]{char}"
                      border_position "top"

                      mode_normal        "#[bg=${base0B},fg=${base02},bold] NORMAL#[bg=${base03},fg=${base0B}]█"
                      mode_locked        "#[bg=${base04},fg=${base02},bold] LOCKED #[bg=${base03},fg=${base04}]█"
                      mode_resize        "#[bg=${base08},fg=${base02},bold] RESIZE#[bg=${base03},fg=${base08}]█"
                      mode_pane          "#[bg=${base0D},fg=${base02},bold] PANE#[bg=${base03},fg=${base0D}]█"
                      mode_tab           "#[bg=${base07},fg=${base02},bold] TAB#[bg=${base03},fg=${base07}]█"
                      mode_scroll        "#[bg=${base0A},fg=${base02},bold] SCROLL#[bg=${base03},fg=${base0A}]█"
                      mode_enter_search  "#[bg=${base0D},fg=${base02},bold] ENT-SEARCH#[bg=${base03},fg=${base0D}]█"
                      mode_search        "#[bg=${base0D},fg=${base02},bold] SEARCHARCH#[bg=${base03},fg=${base0D}]█"
                      mode_rename_tab    "#[bg=${base07},fg=${base02},bold] RENAME-TAB#[bg=${base03},fg=${base07}]█"
                      mode_rename_pane   "#[bg=${base0D},fg=${base02},bold] RENAME-PANE#[bg=${base03},fg=${base0D}]█"
                      mode_session       "#[bg=${base0E},fg=${base02},bold] SESSION#[bg=${base03},fg=${base0E}]█"
                      mode_move          "#[bg=${base0F},fg=${base02},bold] MOVE#[bg=${base03},fg=${base0F}]█"
                      mode_prompt        "#[bg=${base0D},fg=${base02},bold] PROMPT#[bg=${base03},fg=${base0D}]█"
                      mode_tmux          "#[bg=${base09},fg=${base02},bold] TMUX#[bg=${base03},fg=${base09}]█"

                      // formatting for inactive tabs
                      tab_normal              "#[bg=${base03},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{floating_indicator}#[bg=${base03},fg=${base02},bold]█"
                      tab_normal_fullscreen   "#[bg=${base03},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{fullscreen_indicator}#[bg=${base03},fg=${base02},bold]█"
                      tab_normal_sync         "#[bg=${base03},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{sync_indicator}#[bg=${base03},fg=${base02},bold]█"

                      // formatting for the current active tab
                      tab_active              "#[bg=${base03},fg=${base09}]█#[bg=${base09},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{floating_indicator}#[bg=${base03},fg=${base02},bold]█"
                      tab_active_fullscreen   "#[bg=${base03},fg=${base09}]█#[bg=${base09},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{fullscreen_indicator}#[bg=${base03},fg=${base02},bold]█"
                      tab_active_sync         "#[bg=${base03},fg=${base09}]█#[bg=${base09},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{sync_indicator}#[bg=${base03},fg=${base02},bold]█"

                      // separator between the tabs
                      tab_separator           "#[bg=${base00}] "

                      // indicators
                      tab_sync_indicator       " "
                      tab_fullscreen_indicator " 󰊓"
                      tab_floating_indicator   " 󰹙"

                      command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                      command_git_branch_format      "#[fg=blue] {stdout} "
                      command_git_branch_interval    "10"
                      command_git_branch_rendermode  "static"

                      datetime        "#[fg=#6C7086,bold] {format} "
                      datetime_format "%A, %d %b %Y %H:%M"
                      datetime_timezone "Europe/Madrid"
                  }
              }
              children
          }
      }
    '';
  };
}
