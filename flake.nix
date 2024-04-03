{
  description = "IcyD NixOS configuration";
  inputs = {
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    lldb-nix-fix.url = "github:mstone/nixpkgs/darwin-fix-vscode-lldb";
  };
  outputs = { self, ... }@inputs:
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
      nixpkgsConfig = { system }:
        let
          unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
          lldb-nix-fix = import inputs.lldb-nix-fix { inherit system; };
        in {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (self: super: { inherit unstable lldb-nix-fix; })
            inputs.neovim-nightly-overlay.overlay
            inputs.nur.overlay
          ];
        };
    in {
      darwinConfigurations = let
        host = darwin.host;
        system = "aarch64-darwin";
      in {
        "${host}" = inputs.darwin.lib.darwinSystem {
          inherit system;
          modules = [ ./nix/system/darwin/darwin-configuration.nix ];
        };
      };
      homeConfigurations = {
        "${linux.user}" = let
          email = linux.email;
          homeDirectory = "/home/${username}";
          system = "x86_64-linux";
          username = linux.user;
        in inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
          modules = [
            inputs.impermanence.nixosModules.home-manager.impermanence
            ./nix/users/${username}/home.nix
          ];
          extraSpecialArgs = {
            inherit stateVersion username homeDirectory email nix-colors;
          };
        };

        "${darwin.user}" = let
          email = darwin.email;
          homeDirectory = "/Users/${username}";
          system = "aarch64-darwin";
          username = darwin.user;
        in inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs (nixpkgsConfig { inherit system; });
          modules = [ ./nix/users/${username}/home.nix ];
          extraSpecialArgs = {
            inherit stateVersion username homeDirectory email nix-colors;
          };
        };
      };
      nixosConfigurations = let
        host = linux.host;
        system = "x86_64-linux";
        username = linux.user;
      in {
        ${host} = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ({ nixpkgs.config.allowUnfree = true; })
            inputs.impermanence.nixosModules.impermanence
            ./nix/system/${host}/configuration.nix
          ];
          specialArgs = { inherit username stateVersion; };
        };
      };
    };
}
