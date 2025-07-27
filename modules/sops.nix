{
  lib,
  inputs,
  ...
}: {
  flake.modules.nixos.sops = {
    imports = lib.optional (inputs.sops-nix.nixosModules ? sops) inputs.sops-nix.nixosModules.sops;
  };

  flake.modules.homeManager.sops = {
    imports = lib.optional (inputs.sops-nix.homeManagerModules ? sops) inputs.sops-nix.homeManagerModules.sops;
  };
}
