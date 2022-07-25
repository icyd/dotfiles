{ config, startup_mode ? "Maximized", ... }: let
  colors = config.colorscheme.colors;
in {
  enable = true;
  settings = {
    alt_send_esc = true;
    bell = {
        animation = "EaseOutExpo";
        duration = 10;
        color = "#${colors.base07}";
    };
    colors = {
      primary = {
          background = "0x${colors.base00}";
          foreground = "0x${colors.base05}";
      };
      cursor = {
          text = "0x${colors.base00}";
          cursor = "0x${colors.base05}";
      };
      normal = {
          black = "0x${colors.base00}";
          red = "0x${colors.base08}";
          green = "0x${colors.base0B}";
          yellow = "0x${colors.base0A}";
          blue = "0x${colors.base0D}";
          magenta = "0x${colors.base0E}";
          cyan = "0x${colors.base0C}";
          white = "0x${colors.base05}";
      };
      # bright = {
      #     black = "0x665c54";
      #     red = "0xfb4934";
      #     green = "0xb8bb26";
      #     yellow = "0xfabd2f";
      #     blue = "0x83a598";
      #     magenta = "0xd3869b";
      #     cyan = "0x8ec07c";
      #     white = "0xfbf1c7";
      # };
      # indexed_colors = [
      #     { index = 16; color = "0xfe8019"; }
      #     { index = 17; color = "0xd65d0e"; }
      #     { index = 18; color = "0x3c3836"; }
      #     { index = 19; color = "0x504945"; }
      #     { index = 20; color = "0xbdae93"; }
      #     { index = 21; color = "0xebdbb2"; }
      # ];
    };
    cursor.style = "Block";
    font = let fontname = "MesloLGS Nerd Font"; in {
        normal = { family = fontname; };
        size = 13;
    };
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
    ];
    live_config_reload = true;
    mouse = { hide_when_typing = true; };
    scrolling = {
        history = 1000;
        multiplier = 3;
    };
    window = {
        inherit startup_mode;
        decorations = "none";
        padding = { x = 5; y = 5; };
    };
  };
}
