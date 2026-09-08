{
  lib,
  config,
  inputs,
  withSystem,
  ...
}: let
  prefix = "hosts/";
in {
  flake.nixosConfigurations =
    config.flake.modules.nixos or {}
    |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (name: module: let
      hostName = lib.removePrefix prefix name;
      inherit (config.flake.meta.hosts.${hostName}) system;
    in {
      name = hostName;
      value = withSystem system ({pkgs, ...}:
        lib.optionalAttrs (pkgs.stdenv.hostPlatform.isLinux) (
          inputs.nixpkgs.lib.nixosSystem {
            modules =
              module.imports
              ++ [
                {
                  networking = {inherit hostName;};
                }
              ];
          }
        ));
    });
  flake.darwinConfigurations =
    config.flake.modules.darwin or {}
    |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
    |> lib.mapAttrs' (name: module: let
      hostName = lib.removePrefix prefix name;
      inherit (config.flake.meta.hosts.${hostName}) system;
    in {
      name = hostName;
      value = withSystem system ({pkgs, ...}:
        lib.optionalAttrs (pkgs.stdenv.hostPlatform.isDarwin) (
          inputs.darwin.lib.darwinSystem {
            modules = [
              module
              {
                networking = {inherit hostName;};
              }
            ];
          }
        ));
    });
}
