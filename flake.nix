{
    description = "IcyD NixOS configuration";
    inputs = {
        nixpkgs.url = "github:NixOs/nixpkgs/nixos-22.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        home-manager = {
            url = "github:nix-community/home-manager/release-22.11";
            inputs.nixpkgs.follows = "nixpkgs";
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

        nixpkgsConfig = { system }:
        let
            unstable = import inputs.nixpkgs-unstable { inherit system; };
        in {
            inherit system;
            config.allowUnfree = true;
            overlays = [
                (self: super: {
                    neovim-unstable = unstable.neovim;
                    neovim-remote = unstable.neovim-remote;
                })
                inputs.neovim-nightly-overlay.overlay
                inputs.nur.overlay
            ];
        };
    in {
        nixosConfigurations = let
            host = "legionix5";
            username = "beto";
            system = "x86_64-linux";
        in {
            ${host} = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ({
                        nixpkgs = nixpkgsConfig { inherit system; };
                    })
                    ./nix/system/${host}/configuration.nix
                ];
                specialArgs = { inherit username stateVersion; };
            };

            aws = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ({
                        nixpkgs = nixpkgsConfig { inherit system; };
                    })
                    ./nix/system/aws/configuration.nix
                ];
                specialArgs = {
                    inherit username stateVersion;
                    modulesPath = inputs.nixpkgs + "/nixos/modules";
                };
            };
        };

        darwinConfigurations = let
            host = "ES-IT00385";
            system = "aarch64-darwin";
        in {
            "${host}" = inputs.darwin.lib.darwinSystem {
                inherit system;
                modules = [
                    ({
                        nixpkgs = nixpkgsConfig { inherit system; };
                    })
                    ./nix/system/darwin/darwin-configuration.nix
                ];
            };
        };

        homeConfigurations = {
            "beto" = let
                system = "x86_64-linux";
                username = "beto";
                homeDirectory = "/home/${username}";
                email = "beto.v25@gmail.com";
            in inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
                modules = [
                    ./nix/modules/home-common.nix
                    ./nix/users/${username}/home.nix
                ];
                extraSpecialArgs = { inherit stateVersion username homeDirectory email nix-colors; };
            };

            "aj.vazquez" = let
                system = "aarch64-darwin";
                username = "aj.vazquez";
                homeDirectory = "/Users/${username}";
                email = "avazquez@contractor.ea.com";
            in inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
                modules = [
                    ./nix/modules/home-common.nix
                    ./nix/users/${username}/home.nix
                ];
                extraSpecialArgs = { inherit stateVersion username homeDirectory email nix-colors; };
            };

            "aws" = let
                system = "x86_64-linux";
                username = "root";
                homeDirectory = "/${username}";
                email = "avazquez@contractor.ea.com";
            in inputs.home-manager.lib.homeManagerConfiguration {
                pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
                modules = [
                    ./nix/modules/home-common.nix
                    ./nix/users/aws/home.nix
                ];
                extraSpecialArgs = { inherit stateVersion username homeDirectory email nix-colors; };
            };
        };
    };
}
