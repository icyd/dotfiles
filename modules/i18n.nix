{
  flake.modules.nixos.base = {
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = rec {
        LC_MONETARY = "en_IE.UTF-8";
        LC_TIME = LC_MONETARY;
      };
    };
  };
}
