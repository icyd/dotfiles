{ lib, ... }:
{
  attrsKeys = lib.mapAttrsToList (k: _: k);
  attrsVals = lib.mapAttrsToList (_: v: v);
  nixPath = lib.mapAttrsToList (k: _: "${k}=flakes:${k}");
  nixRegistry = lib.mapAttrs (_: flake: { inherit flake; });
}
