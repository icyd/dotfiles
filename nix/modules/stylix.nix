{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 14;
    };
    fonts = let
      package = pkgs.dejavu_fonts;
    in {
      sizes.terminal = 15;
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
    image = ../../assets/wallpaper.jpg;
    polarity = "dark";
  };
}
