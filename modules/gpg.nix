{
  flake.modules.darwin.gpg = {
    programs.gnupg.agent.enable = true;
  };
  flake.modules.homeManager.gpg = {
    programs.gpg = {
      enable = true;
      settings.keyserver = "hkps://keys.openpgp.org";
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 3600;
      defaultCacheTtlSsh = 10800;
    };
  };
}
