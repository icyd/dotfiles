{ config, pkgs, lib, email, ... }: {
    home.packages = with pkgs; [
      binutils
      cmake
      ccls
      dnsutils
      faas-cli
      gcc
      gdb
      go_1_18
      gtop
      vifm
    ];
    programs.bat = {
        enable = true;
        config = { theme = "base16"; };
    };
    programs.broot.enable = true;
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.home-manager.enable = true;
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs config; gpgInit = false; };
    xdg.configFile = {
        nvim.source = ../../../nvim;
        "tmux/tmux.remote.conf".source = ../../../tmux/tmux.remote.conf;
        tmuxp.source = ../../../tmux/tmuxp;
    };

}
