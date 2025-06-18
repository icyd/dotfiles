{
  flake.modules.nixos.audio = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      pavucontrol
      qpwgraph
    ];
    security.rtkit.enable = true;
    services.pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      pulse.enable = true;
    };
  };
}
