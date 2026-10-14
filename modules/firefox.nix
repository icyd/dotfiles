{lib, ...}: {
  flake.modules.homeManager.firefox = {
    config,
    pkgs,
    ...
  }: {
    programs.firefox = let
      dnie = pkgs.callPackage ./_dnie.nix {libassuan = pkgs.mv.fast.versions.libassuan."2.5.7";};
    in {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      package = pkgs.firefox;
      pkcs11Modules = [
        dnie
      ];
      policies.SecurityDevices = {
        "DNIe" = "${dnie}/lib/mozilla/pkcs11-modules/libpkcs11-dnie.so";
      };
      profiles.default = {
        extensions = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            firenvim
            gopass-bridge
            vimium
          ];
        };
        settings = {
          "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
          "media.ffmpeg.vaapi.enabled" = true;
        };
      };
    };
    stylix.targets.firefox.profileNames = ["default"];
  };
}
