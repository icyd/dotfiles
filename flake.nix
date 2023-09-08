{
    description = "IcyD NixOS configuration";
    inputs = {
        nixpkgs.url = "github:NixOs/nixpkgs/nixos-23.05";

        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        impermanence.url = "github:nix-community/impermanence";
        home-manager = {
            url = "github:nix-community/home-manager/release-23.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nur.url = "github:nix-community/NUR";
     #    neovim-nightly-overlay = {
	    # url = "github:nix-community/neovim-nightly-overlay?rev=c57746e2b9e3b42c0be9d9fd1d765f245c3827b7";
     #        inputs.nixpkgs.url = "github:nixos/nixpkgs";
     #    };
        neovim-nightly-overlay = {
	    url = "github:nix-community/neovim-nightly-overlay";
            inputs.nixpkgs.url = "github:nixos/nixpkgs";
        };
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
        awsHostname = "aws-avazquez";

        nixpkgsConfig = { system }:
        let
            unstable = import inputs.nixpkgs-unstable { inherit system; };
        in {
            inherit system;
            config.allowUnfree = true;
            overlays = [
                (self: super: {
                    ghc-unstable = unstable.ghc;
                    cabal-install-unstable = unstable.cabal-install;
                    stack-unstable = unstable.stack;
                    hsl-unstable = unstable.haskell-language-server;
                    neovim-unstable = unstable.neovim;
                    neovim-remote = unstable.neovim-remote;
                    nushell-unstable = unstable.nushellFull;
                    starship-unstable = unstable.starship;
                    zellij-unstable = unstable.zellij;
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
                    inputs.impermanence.nixosModules.impermanence
                    ({
                        nixpkgs = nixpkgsConfig { inherit system; };
                    })
                    ./nix/system/${host}/configuration.nix
                ];
                specialArgs = { inherit username stateVersion; };
            };

            ${awsHostname} = let
                username = "root";
                homeDirectory = "/${username}";
                email = "avazquez@contractor.ea.com";
            in inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ({
                        nixpkgs = nixpkgsConfig { inherit system; };
                    })
                    ./nix/system/aws/configuration.nix
                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            users.${username} = import ./nix/users/aws/home.nix;
                            sharedModules = [
                                ./nix/modules/home-common.nix
                            ];
                            useGlobalPkgs = true;
                            extraSpecialArgs = {
                                inherit stateVersion username homeDirectory email nix-colors;
                            };
                        };
                    }
                ];
                specialArgs = {
                    inherit username stateVersion;
                    modulesPath = inputs.nixpkgs + "/nixos/modules";
                    hostname = awsHostname;
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
                        nixpkgs = nixpkgsConfig { system = "aarch64-darwin"; };
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
                    inputs.impermanence.nixosModules.home-manager.impermanence
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
        };
    };
}
