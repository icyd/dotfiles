{
  lib,
  config,
  inputs,
  withSystem,
  ...
}: let
  prefix = "users/";
in
  {
    imports = lib.optionals (inputs.home-manager ? flakeModules) [inputs.home-manager.flakeModules.home-manager];
  }
  // (
    lib.optionalAttrs (inputs.home-manager ? flakeModules) {
      flake.homeConfigurations =
        config.flake.modules.homeManager or {}
        |> lib.filterAttrs (name: _module: lib.hasPrefix prefix name)
        |> lib.mapAttrs' (name: module: let
          username = lib.removePrefix prefix name;
          inherit (config.flake.meta.hosts.${config.flake.meta.users.${username}.host}) system;
        in {
          name = username;
          value = withSystem system ({pkgs, ...}:
            lib.optionalAttrs pkgs.stdenv.isLinux (
              inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules =
                  module.imports
                  ++ [
                    {
                      home = let
                        homeDirectory =
                          if pkgs.stdenv.isLinux
                          then "/home/${username}"
                          else "/Users/${username}";
                      in {
                        inherit username homeDirectory;
                      };
                    }
                  ];
              }
            ));
        });
    }
  )
