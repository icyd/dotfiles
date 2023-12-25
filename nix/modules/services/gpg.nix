{ pinentryFlavor }: {
  inherit pinentryFlavor;
  defaultCacheTtl = 3600;
  defaultCacheTtlSsh = 10800;
  enable = true;
  enableSshSupport = true;
  sshKeys = [ "B0C47FB7645C3D56DE9175B27C122872D309D7EC" ];
}
