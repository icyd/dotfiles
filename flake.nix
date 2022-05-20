{
    description = "IcyD NixOS configuration";
    inputs = {
        home-manager = {
            url = "github:nix-community/home-manager/release-21.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        nixpkgs.url = "nixpkgs/nixos-21.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nur.url = "github:nix-community/NUR";
    };
    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nur, ... }:
    let
        system = "x86_64-linux";
        username = "beto";
        homeDirectory = "/home/${username}";
        email = "beto.v25@gmail.com";
        unstable = import nixpkgs-unstable {
            inherit system;
        };
        pkgs = import nixpkgs {
            inherit system;
        };
        nixpkgs-config = {
            overlays = [
                (self: super: {
                    neovim = unstable.neovim;
                    neovim-unwrapped = unstable.neovim-unwrapped;
                    tmuxPlugins = pkgs.tmuxPlugins // {
                        tmux-thumbs = unstable.tmuxPlugins.tmux-thumbs;
                    };
                })
                nur.overlay
            ];
            config.allowUnfree = true;
        };
    in {
        nixosConfigurations = {
            legionix5 = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ({
                        nixpkgs = nixpkgs-config;
                    })
                    ./nix/system/configuration.nix
                ];
                specialArgs = { inherit username; };
            };
        };
        homeManagerConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
            inherit system username homeDirectory;
            stateVersion = "21.11";
            extraSpecialArgs = { inherit email; };
            configuration = {
                nixpkgs = nixpkgs-config;
                imports = [
                    ./nix/users/${username}/home.nix {}
                ];
            };
        };
    };
}
