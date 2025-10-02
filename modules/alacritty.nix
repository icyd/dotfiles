{lib, ...}: {
  flake.modules.homeManager.base = {config, ...}: {
    programs.alacritty = {
      enable = true;
      settings = {
        window.startup_mode = "Fullscreen";
        terminal.shell = {
          program = "${lib.getExe config.programs.zsh.package}";
          args = ["-c" "nu"];
        };
        keyboard.bindings = [
          {
            key = "l";
            mods = "Command";
            chars = "\\u001bl";
          }
          {
            key = "h";
            mods = "Command";
            chars = "\\u001bh";
          }
          {
            key = "k";
            mods = "Command";
            chars = "\\u001bk";
          }
          {
            key = "j";
            mods = "Command";
            chars = "\\u001bj";
          }
          # {
          #   key = "B";
          #   mods = "Command";
          #   chars = ''\\x1b\\x62'';
          # }
          # {
          #   key = "A";
          #   mods = "Command";
          #   chars = ''\\x1b\\x61'';
          # }
          # {
          #   key = "X";
          #   mods = "Command";
          #   chars = ''\\x1b\\x78'';
          # }
        ];
      };
    };
  };
}
