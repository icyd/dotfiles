{lib, ...}: let
  caches = {
    "https://cache.iog.io" = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";
    "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    "https://hyprland.cachix.org" = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    "https://devenv.cachix.org" = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    "https://numtide.cachix.org" = "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=";
    "https://icyd.cachix.org" = "icyd.cachix.org-1:gndst9U1QOpne+Ib7Dx5W70MNHJy6bezdPhQHIJhy8I=";
  };
in rec {
  flake.modules.nixos.base = {
    nix.settings = {
      download-buffer-size = 536870912;
      substituters = lib.attrNames caches;
      trusted-public-keys = lib.attrValues caches;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  flake.modules.darwin.base = flake.modules.nixos.base;
}
