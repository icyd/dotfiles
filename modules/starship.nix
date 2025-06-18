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
        # kubernetes = {
        #   contexts = [
        #     {
        #       context_pattern = ".*-prod(?<version>-v[^-]+)?-.*";
        #       context_alias = "Prod";
        #       style = "red bold";
        #     }
        #     {
        #       context_pattern = ".*-load(?<version>-v[^-]+)?-.*";
        #       context_alias = "Load$version";
        #       style = "orange";
        #     }
        #     {
        #       context_pattern = ".*-nonprod(?<version>-v[^-]+)?-.*";
        #       context_alias = "Nonprod$version";
        #       style = "green";
        #     }
        #   ];
        # };
      };
    };
  };
}
