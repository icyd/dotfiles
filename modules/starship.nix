{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        battery = {
          disabled = false;
          threshold = 100;
        };
        command_timeout = 1200;
        haskell.disabled = true;
        nodejs.disabled = true;
        kubernetes.disabled = false;
        time = {
          disabled = false;
          time_format = "%H:%M";
        };
      };
    };
  };
}
