{
  lib,
  inputs,
  ...
}: let
  stylixModule = {pkgs, ...}: {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
      fonts = let
        package = pkgs.dejavu_fonts;
      in {
        sizes = {
          applications = 14;
          desktop = 14;
          terminal = 15;
        };
        serif = {
          inherit package;
          name = "DejaVu Serif";
        };
        sansSerif = {
          inherit package;
          name = "DejaVu Sans";
        };
        monospace = {
          package = pkgs.nerd-fonts.anonymice;
          name = "AnonymicePro Nerd Font";
        };
      };
      image = ../../config/assets/wallpaper.jpg;
      polarity = "dark";
    };
  };
in {
  flake.modules.nixos.base = lib.optionalAttrs (inputs.stylix ? nixosModules) {
    imports = [inputs.stylix.nixosModules.stylix stylixModule];
  };
  flake.modules.homeManager.base = {pkgs, ...}:
    lib.optionalAttrs (inputs.stylix ? homeModules) {
      imports = [inputs.stylix.homeModules.stylix stylixModule];
      stylix.iconTheme = lib.optionalAttrs pkgs.stdenv.isLinux {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };
}
