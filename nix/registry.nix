{ lib, inputs, ... }:
let
  mylib = import ./mylib.nix { inherit lib; };
  cache = {
    "https://cache.flox.dev" = "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=";
    "https://cache.iog.io" = "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=";
    "https://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  };
  substituters = mylib.attrsKeys cache;
  trusted-public-keys = mylib.attrsVals cache;
in
{
  nix = {
    nixPath = mylib.nixPath inputs;
    registry = mylib.nixRegistry inputs;
    settings = {
      inherit substituters trusted-public-keys;
    };
  };
}
