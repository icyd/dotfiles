rec {
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
      gc = {
        automatic = !config.programs.nh.clean.enable;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      package = pkgs.nixVersions.stable;
    };
  };
  flake.modules.darwin.base = flake.modules.nixos.base;
}
