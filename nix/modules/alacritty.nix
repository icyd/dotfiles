{ config, shell, shellArgs ? [ ], font, startup_mode ? "Maximized", ... }:
let colors = config.colorScheme.colors;
in {
  enable = true;
  settings = {
    inherit font;
    bell = {
      animation = "EaseOutExpo";
      color = "#${colors.base07}";
      duration = 10;
    };
    colors = {
      # bright = {
      #     black = "0x665c54";
      #     blue = "0x83a598";
      #     cyan = "0x8ec07c";
      #     green = "0xb8bb26";
      #     magenta = "0xd3869b";
      #     red = "0xfb4934";
      #     white = "0xfbf1c7";
      #     yellow = "0xfabd2f";
      # };
      cursor = {
        cursor = "0x${colors.base05}";
        text = "0x${colors.base00}";
      };
      # indexed_colors = [
      #     { index = 16; color = "0xfe8019"; }
      #     { index = 17; color = "0xd65d0e"; }
      #     { index = 18; color = "0x3c3836"; }
      #     { index = 19; color = "0x504945"; }
      #     { index = 20; color = "0xbdae93"; }
      #     { index = 21; color = "0xebdbb2"; }
      # ];
      normal = {
        black = "0x${colors.base00}";
        blue = "0x${colors.base0D}";
        cyan = "0x${colors.base0C}";
        green = "0x${colors.base0B}";
        magenta = "0x${colors.base0E}";
        red = "0x${colors.base08}";
        white = "0x${colors.base05}";
        yellow = "0x${colors.base0A}";
      };
      primary = {
        background = "0x${colors.base00}";
        foreground = "0x${colors.base05}";
      };
    };
    cursor.style = "Block";
    key_bindings = [
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
        chars = "\\x1b\\x6c";
      }
      {
        key = "H";
        mods = "Command";
        chars = "\\x1b\\x68";
      }
      {
        key = "K";
        mods = "Command";
        chars = "\\x1b\\x6b";
      }
      {
        key = "J";
        mods = "Command";
        chars = "\\x1b\\x6a";
      }
      {
        key = "L";
        mods = "Alt";
        chars = "\\x1b\\x6c";
      }
      {
        key = "H";
        mods = "Alt";
        chars = "\\x1b\\x68";
      }
      {
        key = "K";
        mods = "Alt";
        chars = "\\x1b\\x6b";
      }
      {
        key = "J";
        mods = "Alt";
        chars = "\\x1b\\x6a";
      }
      {
        key = "C";
        mods = "Alt";
        chars = "\\x1b\\x63";
      }
      {
        key = "B";
        mods = "Command";
        chars = "\\x1b\\x62";
      }
      {
        key = "A";
        mods = "Command";
        chars = "\\x1b\\x61";
      }
      {
        key = "X";
        mods = "Command";
        chars = "\\x1b\\x78";
      }
      {
        key = "P";
        mods = "Command";
        chars = "\\x1b\\x70";
      }
      {
        key = "D";
        mods = "Command";
        chars = "\\x1b\\x64";
      }
      {
        key = "U";
        mods = "Command";
        chars = "\\x1b\\x75";
      }
      {
        key = "Key9";
        mods = "Command";
        chars = "\\x1d";
      }
      {
        key = "RBracket";
        mods = "Control";
        chars = "\\x1d";
      }
      {
        key = "E";
        mods = "Command";
        chars = "\\x1b\\x65";
      }
    ];
    live_config_reload = true;
    mouse = { hide_when_typing = true; };
    scrolling = {
      history = 1000;
      multiplier = 3;
    };
    shell.program = shell;
    shell.args = shellArgs;
    window = {
      inherit startup_mode;
      decorations = "none";
      option_as_alt = "Both";
      padding = {
        x = 5;
        y = 5;
      };
    };
  };
}
