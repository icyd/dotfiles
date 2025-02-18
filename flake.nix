{
  description = "IcyD NixOS configuration";
  inputs = {
    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    bash-env-nushell = {
      url = "github:tesujimath/bash-env-nushell/main";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.bash-env-json.follows = "bash-env-json";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    impermanence.url = "github:nix-community/impermanence";
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh_plus.url = "github:ToyVo/nh_plus";
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:icyd/nixvim";
    nur.url = "github:nix-community/NUR";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xkb = {
      url = "github:icyd/icyd-layouts/dev";
      flake = false;
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { ... }@inputs:
    let
      definitions = import ./nix/definitions.nix { inherit inputs; };
      users = definitions.users;
      nixpkgsConfig = definitions.nixpkgsConfig;
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
              pkgs = import inputs.nixpkgs (nixpkgsConfig {
                inherit system;
              });
              modules = [
                ./nix/system/darwin/darwin-configuration.nix
                inputs.nh_plus.nixDarwinModules.prebuiltin
                # inputs.nh_plus.nixDarwinModules.default
                inputs.stylix.darwinModules.stylix
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
              modules = [
                inputs.stylix.homeManagerModules.stylix
                ./nix/users/${username}/home.nix
              ] ++ additionalModules;
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
                { nixpkgs = (nixpkgsConfig { inherit system; }); }
                inputs.stylix.nixosModules.stylix
                inputs.kmonad.nixosModules.default
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
              additionalModules = [
                inputs.impermanence.nixosModules.impermanence
                inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
              ];
            };
          };
    };
}
