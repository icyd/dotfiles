{
  flake.modules.nixos.base = {pkgs, ...}: {
    fonts = {
      enableDefaultPackages = true;
      packages =
        (with pkgs; [
          cantarell-fonts
          eb-garamond
          fira-code
          liberation_ttf
          roboto
        ])
        ++ (with pkgs.nerd-fonts; [
          anonymice
          meslo-lg
          noto
          sauce-code-pro
        ]);
      fontconfig.enable = true;
    };
  };
  flake.modules.homeManager.base = {pkgs, ...}: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs.nerd-fonts; [
      anonymice
      hack
      inconsolata
      meslo-lg
      sauce-code-pro
    ];
  };
}
