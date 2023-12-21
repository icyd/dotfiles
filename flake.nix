{
    description = "IcyD NixOS configuration";
    inputs = {
        nixpkgs.url = "github:NixOs/nixpkgs/nixos-23.11";

        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            # inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
        neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
        darwin = {
            url = "github:lnl7/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nix-colors.url = "github:misterio77/nix-colors";
    };

    outputs = { self, ... }@inputs:
    let
        stateVersion = "22.05";
        nix-colors = inputs.nix-colors;
        linux = {
            user = "beto";
            email = "beto.v25@gmail.com";
            host = "legionix5";
        };
        darwin = {
            user = "aj.vazquez";
            email = "aj.vazquez@globant.com";
            host= "ES-IT00385";
        };

        nixpkgsConfig = { system }:
        let
            unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
            };
        in {
            inherit system;
            config.allowUnfree = true;
            overlays = [
                (self: super: {
                    inherit unstable;
                })
                inputs.neovim-nightly-overlay.overlay
                inputs.nur.overlay
            ];
        };
    in {
        nixosConfigurations = let
            host = linux.host;
            username = linux.user;
            system = "x86_64-linux";
        in {
            ${host} = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    inputs.impermanence.nixosModules.impermanence
                    ./nix/system/${host}/configuration.nix
                ];
                specialArgs = { inherit username stateVersion; };
            };
        };

        darwinConfigurations = let
            host = darwin.host;
            system = "aarch64-darwin";
        in {
            "${host}" = inputs.darwin.lib.darwinSystem {
                inherit system;
                modules = [
                    ./nix/system/darwin/darwin-configuration.nix
                ];
            };
        };

        homeConfigurations = {
            "${linux.user}" = let
                system = "x86_64-linux";
                username = linux.user;
                homeDirectory = "/home/${username}";
                email = linux.email;
            in inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
                modules = [
                    inputs.impermanence.nixosModules.home-manager.impermanence
                    ./nix/modules/home-common.nix
                    ./nix/users/${username}/home.nix
                ];
                extraSpecialArgs = { inherit stateVersion username homeDirectory email nix-colors; };
            };

            "${darwin.user}" = let
                system = "aarch64-darwin";
                username = darwin.user;
                homeDirectory = "/Users/${username}";
                email = darwin.email;
            in inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
                modules = [
                    ./nix/modules/home-common.nix
                    ./nix/users/${username}/home.nix
                ];
                extraSpecialArgs = { inherit stateVersion username homeDirectory email nix-colors; };
            };
        };
    };
}
