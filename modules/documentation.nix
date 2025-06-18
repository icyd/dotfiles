{
  flake.modules.nixos.base = {
    documentation.man.generateCaches = true;
  };
  flake.modules.homeManager.base = {
    programs.man.generateCaches = true;
  };
}
