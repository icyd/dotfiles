{ pkgs, lib, config, email, ... }: let
    brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
    zellijConfigDir = if pkgs.stdenv.isDarwin then
        "${config.home.homeDirectory}/Library/Application Support/org.Zellij-Contributors.Zellij"
    else
        "${config.xdg.configHome}/zellij";
in {
    home.sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        PATH = "${brewPrefix}/bin:${brewPrefix}/opt/coreutils/libexec/gnubin:$PATH";
        MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
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
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs config; };
    xdg.configFile = {
        nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
        tmuxp.source = ../../../tmux/tmuxp;
        wezterm.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/wezterm";
    };

    home.file = {
        "${zellijConfigDir}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zellij";
    };

    home.packages = with pkgs; [
        awscli2
        checkov
        dive
        (pkgs.callPackage ../../modules/go/gig/default.nix {})
        faas-cli
        go_1_18
        gopass
        gopass-jsonapi
        luajit
        luajitPackages.luarocks
        # haskell
        ghc-unstable
        stack-unstable
        cabal-install-unstable
        hsl-unstable
        istioctl
        kind
        krew
        kubectl
        kubernetes-helm
        nodejs
        helmfile
        mosh
        pueue-unstable
        rustup
        # rust-analyzer
        reattach-to-user-namespace
        saml2aws
        stern
        wget
    ];
}
