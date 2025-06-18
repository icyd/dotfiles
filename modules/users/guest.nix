{
  flake.modules.nixos."users/guest" = {
    users.users.guest = {
      hashedPassword = "$y$j9T$ttfF0hwJU50Sgn5VgxD/J/$m27oLpo5xQTN/6Lzdulqj72GRFGX9ixLLN8q.I7LS25";
      isNormalUser = true;
    };
  };
}
