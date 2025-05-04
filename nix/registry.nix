{
  lib,
  inputs,
  ...
}: let
  mylib = {
    attrsKeys = lib.mapAttrsToList (k: _: k);
    attrsVals = lib.mapAttrsToList (_: v: v);
    nixPath = lib.mapAttrsToList (k: _: "${k}=flakes:${k}");
    nixRegistry = lib.mapAttrs (_: flake: {inherit flake;});
  };
  cache = {
    "https://cache.iog.io" = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";
    "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    "https://devenv.cachix.org" = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
  };
  substituters = mylib.attrsKeys cache;
  trusted-public-keys = mylib.attrsVals cache;
in {
  nix = {
    nixPath = mylib.nixPath inputs;
    registry = mylib.nixRegistry inputs;
    settings = {
      inherit substituters trusted-public-keys;
    };
  };
}
