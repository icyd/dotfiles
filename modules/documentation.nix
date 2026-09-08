{
  flake.modules.nixos.base = {
    documentation.man.generateCaches = false;
  };
  flake.modules.homeManager.base = {
    programs.man.generateCaches = false;
  };
}
