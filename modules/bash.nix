{
  flake.modules.homeManager.bash = {
    pkgs,
    config,
    ...
  }: {
    programs.bash = {
      enable = true;
      package = pkgs.bashInteractive;
      historySize = 10000;
      historyFile = "${config.xdg.dataHome}/bash/history";
      # shellAliases = {
      #   cdr = "cd-gitroot";
      #   d = "dirs -v";
      #   dc = "dirs -c";
      # };
    };
  };
}
