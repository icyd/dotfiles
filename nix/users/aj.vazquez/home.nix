{ pkgs, lib, config, email, ... }: {
    home.sessionVars = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
    };

    programs.alacritty = import ../../modules/alacritty.nix { inherit config; startup_mode = "Fullscreen"; };
    programs.bat = {
        enable = true;
        config = { theme = "base16"; };
    };
    programs.broot.enable = true;
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.home-manager.enable = true;
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs; };
    xdg.configFile = {
        nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
        tmuxp.source = ../../../tmux/tmuxp;
    };

    home.packages = with pkgs; [
      dive
      (pkgs.callPackage ../../modules/go/gig/default.nix {})
      faas-cli
      go_1_17
      gopass
      gopass-jsonapi
      luajit
      luajitPackages.luarocks
      kind
      nodejs
      helmfile
      mosh
      rustup
      rust-analyzer
      reattach-to-user-namespace
      wget
    ];
}
