{
  lib,
  inputs,
  ...
}: let
  mylib = {
    attrsKeys = lib.mapAttrsToList (k: _: k);
    attrsVals = lib.mapAttrsToList (_: v: v);
    nixPath = lib.mapAttrsToList (k: _: "${k}=/etc/nix/channels/${k}");
    nixPathLinks = lib.mapAttrs' (k: v: {
      name = "nix/channels/${k}";
      value = {source = v.outPath;};
    });
    nixRegistry = lib.mapAttrs (_: flake: {inherit flake;});
  };
  cache = {
    "https://cache.iog.io" = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";
    "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    "https://devenv.cachix.org" = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    "https://cache.flox.dev" = "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=";
  };
  substituters = mylib.attrsKeys cache;
  trusted-public-keys = mylib.attrsVals cache;
  nixpkgsFlakes = lib.filterAttrs (k: _: lib.hasPrefix "nixpkgs" k) inputs;
in {
  nix = {
    channel.enable = true;
    nixPath = mylib.nixPath nixpkgsFlakes;
    registry = mylib.nixRegistry nixpkgsFlakes;
    settings = {
      inherit substituters trusted-public-keys;
    };
  };
  environment.etc = mylib.nixPathLinks nixpkgsFlakes;
}
