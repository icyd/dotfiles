{
  description = "IcyD NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    nixpkgs-darwin.url = "github:NixOs/nixpkgs/nixpkgs-21.11-darwin";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    nixpkgs-darwin,
    darwin,
    home-manager-darwin,
    nix-colors,
    ...
  }: let
    stateVersion = "21.11";

    nixpkgsConfig = { system }:
    let
      stable = import nixpkgs { inherit system; };
      unstable = import nixpkgs-unstable { inherit system; };
    in {
      config.allowUnfree = true;
      overlays = [
        (self: super: {
          alacritty = unstable.alacritty;
          neovim = unstable.neovim;
          neovim-unwrapped = unstable.neovim-unwrapped;
          tmuxPlugins = stable.tmuxPlugins // {
            tmux-fzf = unstable.tmuxPlugins.tmux-fzf;
            tmux-thumbs = unstable.tmuxPlugins.tmux-thumbs;
          };
          yq-go = unstable.yq-go;
        })
        nur.overlay
      ];
    };
  in {
    nixosConfigurations = let
      host = "legionix5";
      username = "beto";
      system = "x86_64-linux";
    in {
      ${host} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({
            nixpkgs = nixpkgsConfig { inherit system; };
          })
          ./nix/system/${host}/configuration.nix
        ];
        specialArgs = { inherit username; };
      };
    };

    darwinConfigurations = let
      host = "ES-IT00385";
    in {
      "${host}" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/system/${host}/darwin-configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "beto" = let
        system = "x86_64-linux";
        username = "beto";
        email = "beto.v25@gmail.com";
      in home-manager.lib.homeManagerConfiguration {
        inherit stateVersion system username;
        homeDirectory = "/home/${username}";
        extraSpecialArgs = { inherit email nix-colors; };
        configuration = {
          imports = [
            ./nix/users/${username}/home.nix {}
          ];
          nixpkgs = nixpkgsConfig { inherit system; };
        };
      };
      "aj.vazquez" = let
        system = "aarch64-darwin";
        username = "aj.vazquez";
        email = "avazquez@contractor.ea.com";
      in home-manager-darwin.lib.homeManagerConfiguration {
        inherit stateVersion system username;
        homeDirectory = "/Users/${username}";
        extraSpecialArgs = { inherit email nix-colors; };
        configuration = {
          imports = [
            ./nix/users/${username}/home.nix {}
          ];
          nixpkgs = nixpkgsConfig { inherit system; };
        };
      };
    };
  };
}
