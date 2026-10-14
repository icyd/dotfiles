{
  flake.modules.nixos.desktop = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      file-roller
      xdg-utils
    ];
    programs = {
      dconf.enable = true;
      regreet = {
        enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs; [
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
