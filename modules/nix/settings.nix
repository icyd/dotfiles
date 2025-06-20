_: rec {
  flake.modules.nixos.base = {
    config,
    pkgs,
    ...
  }: {
    nix = {
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];
      };
      gc =
        {
          automatic =
            if pkgs.stdenv.isLinux
            then !config.programs.nh.clean.enable
            else true;
          options = "--delete-older-than 30d";
        }
        // (
          if pkgs.stdenv.isDarwin
          then {
            interval = {
              Hour = 0;
              Minute = 0;
              Weekday = 7;
            };
          }
          else {
            dates = "weekly";
          }
        );
      package = pkgs.nixVersions.stable;
    };
  };
  flake.modules.darwin.base = flake.modules.nixos.base;
}
