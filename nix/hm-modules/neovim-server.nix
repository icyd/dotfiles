{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.my.services.neovim-server;
in {
  options.my.services.neovim-server = {
    enable = lib.mkEnableOption "neovim server";
    package = lib.mkPackageOption pkgs "neovim" {};
  };

  config = lib.mkIf cfg.enable {
    systemd.user = {
      services = {
        neovim-headless = let
          nvim = lib.getExe' cfg.package "nvim";
        in {
          Service.Environment = "PATH=/run/current-system/sw/bin:${config.home.homeDirectory}/.nix-profile/bin";
          Service.ExecStart = ''${pkgs.zsh}/bin/zsh -c "${nvim} --headless --listen ::1:9091"'';
          Service.Restart = "always";
          Service.RestartSec = 3;
          Service.Type = "simple";
          Unit.Description = "Neovim headless server";
          Unit.StartLimitBurst = 5;
          Unit.StartLimitIntervalSec = 300;
        };
        neovim-server = let
          dependencies = [
            "neovim-server.socket"
            "neovim-headless.service"
          ];
        in {
          Service.ExecStart = "/run/current-system/sw/lib/systemd/systemd-socket-proxyd --exit-idle-time 300 ::1:9091";
          Service.Type = "notify";
          Unit.After = dependencies;
          Unit.Description = "Neovim socket activation proxyd";
          Unit.Requires = dependencies;
        };
      };
      sockets = {
        neovim-server = {
          Install.WantedBy = ["sockets.target"];
          Socket.BindIPv6Only = "both";
          Socket.ListenStream = 9090;
          Unit.Description = "Neovim headless server socket";
        };
      };
    };
  };
}
