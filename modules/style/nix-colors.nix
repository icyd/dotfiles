{
  lib,
  inputs,
  ...
}: {
  flake.modules.homeManager.base =
    {
      imports =
        lib.optional (inputs.nix-colors ? homeManagerModule)
        inputs.nix-colors.homeManagerModule;
    }
    // (lib.optionalAttrs (inputs.nix-colors ? homeManagerModule) {
      colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
    });
}
