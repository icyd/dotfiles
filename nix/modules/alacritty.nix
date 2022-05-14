{ ... }: {
  enable = true;
  settings = {
      bell = {
          animation = "EaseOutExpo";
          duration = 10;
          color = "#ffffff";
      };
      colors = {
          primary = {
              background = "0x282828";
              foreground = "0xd5c4a1";
          };
          cursor = {
              text = "0x282828";
              cursor = "0xd5c4a1";
          };
          normal = {
              black = "0x282828";
              red = "0xfb4934";
              green = "0xb8bb26";
              yellow = "0xfabd2f";
              blue = "0x83a598";
              magenta = "0xd3869b";
              cyan = "0x8ec07c";
              white = "0xd5c4a1";
          };
          bright = {
              black = "0x665c54";
              red = "0xfb4934";
              green = "0xb8bb26";
              yellow = "0xfabd2f";
              blue = "0x83a598";
              magenta = "0xd3869b";
              cyan = "0x8ec07c";
              white = "0xfbf1c7";
          };
          indexed_colors = [
              { index = 16; color = "0xfe8019"; }
              { index = 17; color = "0xd65d0e"; }
              { index = 18; color = "0x3c3836"; }
              { index = 19; color = "0x504945"; }
              { index = 20; color = "0xbdae93"; }
              { index = 21; color = "0xebdbb2"; }
          ];
      };
      cursor.style = "Block";
      font = let fontname = "MesloLGS Nerd Font"; in {
          normal = { family = fontname; style = "Semibold"; };
          bold = { family = fontname; style = "Bold"; };
          italic = { family = fontname; style = "Italic"; };
          size = 11;
      };
      live_config_reload = true;
      mouse = { hide_when_typing = true; };
      scrolling = {
          history = 1000;
          multiplier = 3;
      };
      window = {
          decoration = "none";
          startup_mode = "Maximized";
          padding = { x = 5; y = 5; };
      };
  };
}
