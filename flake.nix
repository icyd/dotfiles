{
  description = "IcyD NixOS configuration";
  inputs = {
    xkb = {
      url = "git+file:icyd-layouts";
      flake = false;
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
  };
  outputs =
    { self, ... }@inputs:
    let
      definitions = import ./nix/definitions.nix { inherit inputs; };
      users = definitions.users;
      nixpkgsConfig = definitions.nixpkgsConfig;
      neovim-override = definitions.neovim-override;
    in
    {
      darwinConfigurations =
        builtins.mapAttrs
          (
            name:
            {
              system,
              username,
              additionalModules ? [ ],
            }:
            inputs.darwin.lib.darwinSystem {
              inherit system;
              modules = [
                ./nix/system/darwin/darwin-configuration.nix
                (neovim-override { inherit system; })
              ] ++ additionalModules;
              specialArgs = {
                inherit username inputs;
              };
            }
          )
          {
            "ES-IT00385" = {
              username = users.darwin.username;
              system = "aarch64-darwin";
            };
          };

      homeConfigurations =
        builtins.mapAttrs
          (
            username:
            {
              email,
              system,
              additionalModules ? [ ],
            }:
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs (nixpkgsConfig {
                inherit system;
              });
              modules = [ ./nix/users/${username}/home.nix ] ++ additionalModules;
              extraSpecialArgs = {
                inherit username email inputs;
              };
            }
          )
          {
            "${users.linux.username}" = {
              email = users.linux.email;
              system = "x86_64-linux";
              additionalModules = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
            };
            "${users.darwin.username}" = {
              email = users.darwin.email;
              system = "aarch64-darwin";
            };
          };

      nixosConfigurations =
        builtins.mapAttrs
          (
            name:
            {
              system,
              username,
              additionalModules ? [ ],
            }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                ({ nixpkgs = (nixpkgsConfig { inherit system; }); })
                (neovim-override { inherit system; })
                ./nix/system/${name}/configuration.nix
              ] ++ additionalModules;
              specialArgs = {
                inherit username inputs;
              };
            }
          )
          {
            "legionix5" = {
              system = "x86_64-linux";
              username = users.linux.username;
              additionalModules = [ inputs.impermanence.nixosModules.impermanence ];
            };
          };
    };
}
