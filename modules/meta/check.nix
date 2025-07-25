{
  lib,
  config,
  ...
}: let
  hostPrefix = "host/";
  userPrefix = "user/";
  systemConfig = lib.mapAttrsToList (name: system: {${system.config.nixpkgs.hostPlatform.system} = {"${hostPrefix}${name}" = system.config.system.build.toplevel;};});
  nixosConfigs =
    config.flake.nixosConfigurations
    |> systemConfig;
  darwinConfigs =
    config.flake.darwinConfigurations
    |> systemConfig;
  hmConfigs =
    config.flake.homeConfigurations
    |> lib.mapAttrsToList (name: hm: {${hm.config.nixpkgs.system} = {"${userPrefix}${name}" = hm.activationPackage;};});
in {
  flake.check =
    [
      nixosConfigs
      darwinConfigs
      hmConfigs
    ]
    |> lib.lists.flatten
    |> lib.attrsets.foldAttrs (item: acc: [item] ++ acc) []
    |> lib.attrsets.mapAttrs (_: lib.attrsets.mergeAttrsList);
}
