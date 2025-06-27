{
  lib,
  config,
  ...
}: {
  options.nixpkgs.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [];
  };
  config.flake = {
    modules = let
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.nixpkgs.allowedUnfreePackages;
    in {
      nixos.base.nixpkgs.config = {inherit allowUnfreePredicate;};
      homeManager.base = args: {
        nixpkgs.config = lib.mkIf (!(args.hasGlobalPkgs or false)) {
          inherit allowUnfreePredicate;
        };
      };
    };
    meta.nixpkgs.allowedUnfreePackages = config.nixpkgs.allowedUnfreePackages;
  };
}
