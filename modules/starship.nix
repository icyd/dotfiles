{
  flake.modules.homeManager.starship = {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1200;
        haskell.disabled = true;
        nodejs.disabled = true;
        kubernetes.disabled = false;
      };
    };
  };
}
