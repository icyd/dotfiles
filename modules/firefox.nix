{lib, ...}: {
  flake.modules.homeManager.firefox = {
    config,
    pkgs,
    ...
  }: {
    programs.firefox = {
      enable = true;
      # policies.SecurityDevices = {
      #   dnie-pkcs11 = "${(pkgs.callPackage ../packages/dnie.nix {})}/usr/lib/libpkcs11-dnie.so";
      # };
      profiles.default = {
        extensions = lib.optionalAttrs pkgs.stdenv.isLinux {
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
