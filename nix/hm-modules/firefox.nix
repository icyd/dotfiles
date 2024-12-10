{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    policies.SecurityDevices = {
      dnie-pkcs11 = "${(pkgs.callPackage ../packages/dnie.nix { })}/usr/lib/libpkcs11-dnie.so";
    };
    profiles.default = {
      extensions = with pkgs; [
        nur.repos.rycee.firefox-addons.gopass-bridge
        nur.repos.rycee.firefox-addons.vimium
      ];
      settings = {
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };

}
