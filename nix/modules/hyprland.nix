{pkgs, ...}: {
  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = pkgs.unstable.hyprland;
    # portalPackage =
    # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    portalPackage = pkgs.unstable.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  security.pam.services.hyprlock = {};
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}
