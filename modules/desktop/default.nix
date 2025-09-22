{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      file-roller
      xdg-utils
    ];
    programs = {
      regreet = {
        enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      xfconf.enable = true;
      xwayland.enable = true;
    };
    services = {
      greetd.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      tumbler.enable = true;
    };
  };
}
