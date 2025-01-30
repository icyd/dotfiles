{
  programs.alacritty = {
    enable = true;
    settings = {
      general.live_config_reload = true;
      mouse = {
        hide_when_typing = true;
      };
      scrolling = {
        history = 1000;
        multiplier = 3;
      };
      window = {
        startup_mode = "Maximized";
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
}
