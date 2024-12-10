{ lib, config, ... }:
let
  cfg = config.alacritty;
in
{
  options.alacritty = with lib; {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable module";
    };
    colors = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "nix-color palette to use";
    };
    font = mkOption {
      type = types.attrs;
      default = "";
      description = "Alacritty's font";
    };
    shell = mkOption {
      type = types.str;
      default = "";
      description = "Shell used by Alacritty";
    };
    shellArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Shell arguments";
    };
    startupMode = mkOption {
      type = types.str;
      default = "Maximized";
      description = "Startup mode for Alacritty";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        font = cfg.font;
        bell = {
          animation = "EaseOutExpo";
          color = "#${cfg.colors.base07}";
          duration = 10;
        };
        colors = {
          cursor = {
            cursor = "0x${cfg.colors.base05}";
            text = "0x${cfg.colors.base00}";
          };
          normal = {
            black = "0x${cfg.colors.base00}";
            blue = "0x${cfg.colors.base0D}";
            cyan = "0x${cfg.colors.base0C}";
            green = "0x${cfg.colors.base0B}";
            magenta = "0x${cfg.colors.base0E}";
            red = "0x${cfg.colors.base08}";
            white = "0x${cfg.colors.base05}";
            yellow = "0x${cfg.colors.base0A}";
          };
          primary = {
            background = "0x${cfg.colors.base00}";
            foreground = "0x${cfg.colors.base05}";
          };
        };
        cursor.style = "Block";
        live_config_reload = true;
        mouse = {
          hide_when_typing = true;
        };
        scrolling = {
          history = 1000;
          multiplier = 3;
        };
        shell.program = cfg.shell;
        shell.args = cfg.shellArgs;
        window = {
          startup_mode = cfg.startupMode;
          decorations = "none";
          option_as_alt = "Both";
          padding = {
            x = 5;
            y = 5;
          };
        };
        keyboard.bindings = [
          {
            key = "Copy";
            action = "Copy";
          }
          {
            key = "Paste";
            action = "Paste";
          }
          {
            key = "L";
            mods = "Command";
            chars = "\\u001b\\u006c";
          }
          {
            key = "H";
            mods = "Command";
            chars = "\\u001b\\u0068";
          }
          {
            key = "K";
            mods = "Command";
            chars = "\\u001b\\u006b";
          }
          {
            key = "J";
            mods = "Command";
            chars = "\\u001b\\u006a";
          }
          {
            key = "L";
            mods = "Alt";
            chars = "\\u001b\\u006c";
          }
          {
            key = "H";
            mods = "Alt";
            chars = "\\u001b\\u0068";
          }
          {
            key = "K";
            mods = "Alt";
            chars = "\\u001b\\u006b";
          }
          {
            key = "J";
            mods = "Alt";
            chars = "\\u001b\\u006a";
          }
          {
            key = "C";
            mods = "Alt";
            chars = "\\u001b\\u0063";
          }
          {
            key = "B";
            mods = "Command";
            chars = "\\u001b\\u0062";
          }
          {
            key = "A";
            mods = "Command";
            chars = "\\u001b\\u0061";
          }
          {
            key = "X";
            mods = "Command";
            chars = "\\u001b\\u0078";
          }
          {
            key = "P";
            mods = "Command";
            chars = "\\u001b\\u0070";
          }
          {
            key = "D";
            mods = "Command";
            chars = "\\u001b\\u0064";
          }
          {
            key = "U";
            mods = "Command";
            chars = "\\u001b\\u0075";
          }
          {
            key = "Key9";
            mods = "Command";
            chars = "\\u001d";
          }
          {
            key = "RBracket";
            mods = "Control";
            chars = "\\u001d";
          }
          {
            key = "E";
            mods = "Command";
            chars = "\\u001b\\u0065";
          }
        ];
      };
    };
  };
}
