{
  lib,
  config,
  ...
}: let
  hostPrefix = "host/";
  userPrefix = "user/";
in {
  flake.check =
    (config.flake.nixosConfigurations
      |> lib.mapAttrsToList (name: nixos: {${nixos.config.nixpkgs.hostPlatform.system} = {"${hostPrefix}${name}" = nixos.config.system.build.toplevel;};})
      |> lib.mkMerge)
    // (config.flake.darwinConfigurations
      |> lib.mapAttrsToList (name: darwin: {${darwin.config.nixpkgs.hostPlatform.system} = {"${hostPrefix}${name}" = darwin.config.system.build.toplevel;};})
      |> lib.mkMerge)
    // (config.flake.homeConfigurations
      |> lib.mapAttrsToList (name: hm: {${hm.config.nixpkgs.system} = {"${userPrefix}${name}" = hm.activationPackage;};})
      |> lib.mkMerge);
}
