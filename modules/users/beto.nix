{
  lib,
  inputs,
  ...
} @ flakeAttrs: {
  flake.meta.users.beto = {
    name = "Alberto Vázquez";
    username = "beto";
    email = "beto.v25@gmail.com";
    host = "legionix5";
  };
  flake.modules.nixos."users/beto" = {pkgs, ...}: {
    users.users = let
      inherit (flakeAttrs.config.flake.meta.users.beto) username;
    in {
      ${username} = {
        extraGroups = [
          "adbusers"
          "input"
          "uinput"
          "networkmanager"
          "video"
          "dialout"
          "libvirtd"
          "wheel"
          "vboxusers"
        ];
        hashedPasswordFile = "/persist/passwords/${username}";
        isNormalUser = true;
        shell = pkgs.zsh;
        uid = 1000;
      };
    };
  };
  flake.modules.homeManager."users/beto" = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.home) username;
  in {
    home = {
      packages = with pkgs; [
        calibre
        celluloid
        discord
        dropbox
        haruna
        kicad-unstable-small
        libreoffice-fresh
        lutris
        # minikube
        nixvim
        # docker-machine-kvm2
        # synapse
        winetricks
        # wineWowPackages.waylandFull
      ];
      persistence."/mnt/nodatacow" = {
        allowOther = false;
        directories = [
          ".qemu"
          ".wine"
          "VirtualBox VMs"
          "Games"
        ];
      };
      persistence."/persist/home/${username}" = {
        allowOther = false;
        directories = [
          "Backups"
          "Calibre Library"
          "Desktop"
          "Documents"
          "Downloads"
          "Movies"
          "Pictures"
          "Projects"
          "scripts"
          "Videos"
        ];
        files = [
          ".wallpaper.jpg"
          ".zsh_history"
        ];
      };
      stateVersion = "22.05";
      sessionVariables = {
        NVIM_SERVER = lib.mkForce "::1:9090";
        WINEDLLOVERRIDES = "winemenubuilder.exe=d";
      };
    };
    services = {
      kanshi.settings = [
        {
          profile = {
            name = "undocked";
            outputs = [
              {
                criteria = "eDP-1";
                scale = 1.5;
                status = "enable";
              }
              {
                criteria = "eDP-2";
                scale = 1.0;
                status = "enable";
              }
            ];
          };
        }
      ];
      neovim-server = {
        enable = true;
        package = pkgs.nixvim;
      };
      pueue = {
        enable = true;
        settings = {
          daemon.default_parallel_tasks = 2;
          shared.use_unix_socket = true;
        };
      };
    };
    imports = with flakeAttrs.config.flake.modules.homeManager;
      [
        base
        firefox
        git
        gpg
        hyprland
        neovim-server
        nushell
        starship
        virtualisation
        zsh
      ]
      ++ [inputs.impermanence.nixosModules.home-manager.impermanence];
  };
}
