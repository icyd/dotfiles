{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    ...
  }: {
    home = {
      file = {
        ".scripts".source = ../config/nushell/scripts;
      };
      packages = with pkgs; [
        age-plugin-yubikey
        age-plugin-fido2-hmac
        ast-grep
        binutils
        devenv
        eza
        fd
        fish
        gopass
        gopass-jsonapi
        git-credential-gopass
        hwatch
        hyperfine
        imagemagick
        jq
        magic-wormhole-rs
        minisign
        mosh
        mvs
        pandoc
        procs
        rage
        ripgrep
        sd
        sops
        texliveSmall
        yq-go
        yubikey-manager
        zenith
      ];
      sessionPath = [
        "/usr/local/bin"
        "$HOME/.local/bin/"
      ];
      sessionVariables = let
        DOTFILES = "${config.home.homeDirectory}/.dotfiles";
        EDITOR = lib.getExe pkgs.nixvimin;
      in rec {
        inherit DOTFILES EDITOR;
        AGE_IDENTITY = "${config.xdg.configHome}/sops/age/keys.txt";
        AGE_RECIPIENT_FILE = "${config.xdg.configHome}/sops/age/recipient.txt";
        AGE_RECIPIENT = "$(cat ${AGE_RECIPIENT_FILE})";
        BROWSER = "firefox";
        NH_FLAKE = DOTFILES;
        LEDGER_DATE_FORMAT = "%Y/%m/%d";
        KUBE_EDITOR = EDITOR;
        NVIM_SERVER = "/tmp/nvimsocket";
        ORGMODE_HOME = "$HOME/Dropbox";
        PAGER = "less";
        PASSWORD_STORE_GENERATED_LENGTH = 12;
        SOPS_AGE_KEY_FILE = AGE_IDENTITY;
        VISUAL = EDITOR;
        VIMWIKI_HOME = ORGMODE_HOME;
      };
      shellAliases = {
        b64d = "base64 -d";
        cat = "bat";
        cl = "clear";
        cdr = "cd-gitroot";
        g = "git";
        jat = "bat -ljson";
        k = "kubectl";
        l = "eza";
        l1 = "eza -1";
        lb = "eza -lb";
        ll = "eza -la";
        llm = "eza -la --sort=modified";
        lx = "eza -lbhHigUmuSa@";
        la = "eza -lbhHigUmuSa";
        nv = "nvim_client";
        nvr = "nvim_server";
        svim = "sudo -E $env.EDITOR";
        tree = "eza --tree";
        yat = "bat -lyaml";
        xat = "bat -lxml";
        zj = "zellij";
        zr = "zellij-runner";
        xssh = "TERM=xterm-256color ssh";
      };
    };
    programs.bat.enable = true;
    programs.direnv = {
      enable = true;
      enableNushellIntegration = false;
      nix-direnv.enable = true;
    };
    programs.home-manager.enable = true;
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = false;
    };
    xdg.enable = true;
  };
}
