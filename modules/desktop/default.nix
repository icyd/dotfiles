{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      sddm-astronaut
      xdg-utils
    ];
    programs.xwayland.enable = true;
    services = {
      displayManager = {
        sddm = {
          enable = true;
          autoNumlock = true;
          wayland.enable = true;
          extraPackages = [pkgs.sddm-astronaut];
          package = pkgs.kdePackages.sddm;
          theme = "sddm-astronaut-theme";
        };
      };
      gvfs.enable = true;
      libinput.enable = true;
    };
  };
}
