{
  flake.modules.nixos.base = {
    documentation.man.cache.enable = false;
  };
  flake.modules.homeManager.base = {
    programs.man.generateCaches = false;
  };
}
