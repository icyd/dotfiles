{
  flake.modules.nixos.base = {
    programs.zsh.enable = true;
    users.mutableUsers = false;
  };
}
