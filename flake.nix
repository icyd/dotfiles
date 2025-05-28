{
  description = "IcyD NixOS configuration";
  inputs = {
    bash-env-json = {
      url = "github:tesujimath/bash-env-json/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bash-env-nushell = {
      url = "github:tesujimath/bash-env-nushell/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.bash-env-json.follows = "bash-env-json";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flox.url = "github:flox/flox/v1.4.2";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:icyd/nixvim";
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    systems,
    ...
  } @ inputs: let
    nixpkgsConfig = {system}: let
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (_self: super: {
          inherit unstable;
          bash-env-json = inputs.bash-env-json.packages.${system}.default;
          bash-env-nushell = inputs.bash-env-nushell.packages.${system}.default;
          flox = inputs.flox.packages.${system}.default;
          nixvim = inputs.nixvim.packages.${system}.default;
          nixvimin = inputs.nixvim.packages.${system}.nvimin;
          zjstatus = inputs.zjstatus.packages.${super.system}.default;
        })
        inputs.nur.overlays.default
      ];
    };
    forAllSystems = inputs.nixpkgs.lib.genAttrs (import systems);
    eachSystem = f: forAllSystems (system: f inputs.nixpkgs.legacyPackages.${system});
    treefmtEval = eachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    checks = forAllSystems (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          treefmt = {
            enable = true;
            package = treefmtEval.${system}.config.build.wrapper;
          };
        };
      };
    });
    devShells = forAllSystems (system: {
      default = inputs.nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      };
    });
    darwinConfigurations =
      builtins.mapAttrs
      (
        _name: {
          system,
          username,
          additionalModules ? [],
        }:
          inputs.darwin.lib.darwinSystem {
            pkgs = import inputs.nixpkgs (nixpkgsConfig {
              inherit system;
            });
            modules =
              [
                ./nix/system/darwin/darwin-configuration.nix
                inputs.sops-nix.darwinModules.sops
                inputs.stylix.darwinModules.stylix
              ]
              ++ additionalModules;
            specialArgs = {
              inherit username inputs;
            };
          }
      )
      {
        "ES-IT00385" = {
          username = "aj.vazquez";
          system = "aarch64-darwin";
        };
      };

    homeConfigurations =
      builtins.mapAttrs
      (
        username: {
          system,
          additionalModules ? [],
        }:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs (nixpkgsConfig {
              inherit system;
            });
            modules =
              [
                inputs.sops-nix.homeManagerModules.sops
                inputs.stylix.homeModules.stylix
                ./nix/users/${username}/home.nix
              ]
              ++ additionalModules;
            extraSpecialArgs = {
              inherit username inputs;
            };
          }
      )
      {
        "beto" = {
          system = "x86_64-linux";
          additionalModules = [inputs.impermanence.nixosModules.home-manager.impermanence];
        };
        "aj.vazquez" = {
          system = "aarch64-darwin";
        };
      };

    nixosConfigurations =
      builtins.mapAttrs
      (
        name: {
          system,
          username,
          additionalModules ? [],
        }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules =
              [
                {nixpkgs = nixpkgsConfig {inherit system;};}
                inputs.stylix.nixosModules.stylix
                inputs.kmonad.nixosModules.default
                inputs.sops-nix.nixosModules.sops
                ./nix/system/${name}/configuration.nix
              ]
              ++ additionalModules;
            specialArgs = {
              inherit username inputs;
            };
          }
      )
      {
        "legionix5" = {
          system = "x86_64-linux";
          username = "beto";
          additionalModules = [
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.lenovo-legion-15arh05h
          ];
        };
      };
  };
}
