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
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
  };
  outputs =
    { self, ... }@inputs:
    let
      stateVersion = "22.05";
      nix-colors = inputs.nix-colors;
      linux = {
        email = "beto.v25@gmail.com";
        host = "legionix5";
        user = "beto";
      };
      darwin = {
        email = "aj.vazquez@globant.com";
        host = "ES-IT00385";
        user = "aj.vazquez";
      };
      nixpkgsConfig =
        { system }:
        let
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (self: super: { inherit unstable; })
            inputs.nur.overlay
          ];
        };
      neovim-override =
        { system }:
        ({ environment.systemPackages = [ inputs.neovim-nightly-overlay.packages.${system}.default ]; });
      inputsToPin =
        let
          lib = inputs.nixpkgs.lib;
        in
        lib.filterAttrs (key: _: lib.strings.hasPrefix "nixpkgs" key) inputs;

    in
    {
      darwinConfigurations =
        builtins.mapAttrs
          (
            name:
            {
              system,
              additionalModules ? [ ],
            }:
            inputs.darwin.lib.darwinSystem {
              inherit system;
              modules = [
                ./nix/system/darwin/darwin-configuration.nix
                (neovim-override { inherit system; })
              ] ++ additionalModules;
            }
          )
          {
            "${darwin.host}" = {
              system = "aarch64-darwin";
            };
          };

      homeConfigurations =
        builtins.mapAttrs
          (
            name:
            {
              email,
              system,
              additionalModules ? [ ],
            }:
            let
              username = name;
              homeDirectory =
                if builtins.isList (builtins.match ".*(darwin).*" system) then
                  "/Users/${name}"
                else
                  "/home/${name}";
            in
            inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = import inputs.nixpkgs (nixpkgsConfig {
                inherit system;
              });
              modules = [ ./nix/users/${name}/home.nix ] ++ additionalModules;
              extraSpecialArgs = {
                inherit
                  stateVersion
                  username
                  homeDirectory
                  email
                  nix-colors
                  ;
              };
            }
          )
          {
            "${linux.user}" = {
              email = linux.email;
              system = "x86_64-linux";
              additionalModules = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
            };
            "${darwin.user}" = {
              email = darwin.email;
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
                inherit username stateVersion;
                inputs = inputsToPin;
                xkb = inputs.xkb;
              };
            }
          )
          {
            ${linux.host} = {
              system = "x86_64-linux";
              username = linux.user;
              additionalModules = [
                # (inputs.nixpkgs.outPath + "/nixos/modules/profiles/perlless.nix")
                inputs.impermanence.nixosModules.impermanence
              ];
            };
          };
    };
}
