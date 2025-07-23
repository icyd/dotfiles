{
  flake.modules.nixos."users/guest" = {config, ...}: {
    users.users.guest =
      {
        isNormalUser = true;
      }
      // (
        if (config ? sops)
        then {hashedPasswordFile = config.sops.secrets."passwords/guest".path;}
        else {hashedPassword = "$y$j9T$ttfF0hwJU50Sgn5VgxD/J/$m27oLpo5xQTN/6Lzdulqj72GRFGX9ixLLN8q.I7LS25";}
      );
  };
}
