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
        btop
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
        mcp-combiner
        minisign
        mosh
        mvs
        pandoc
        procs
        rage
        ripgrep
        sd
        sharedserver
        sops
        texliveSmall
        yq-go
        yubikey-manager
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
    systemd.user.services.klipper-stunnel = let
      stunnelConfig = pkgs.writeText "stunnel.conf" ''
        foreground = yes

        [orcaslicer-proxy]
        client = yes
        accept = 127.0.0.1:8080
        connect = n3pro.home.arpa:443
        CAfile = ${config.home.homeDirectory}/.stunnel/ca.crt
        cert = ${config.home.homeDirectory}/.stunnel/stunnel.crt
        key = ${config.home.homeDirectory}/.stunnel/stunnel.key
        options = DONT_INSERT_EMPTY_FRAGMENTS
        options = NO_COMPRESSION
        socket = l:SO_SNDBUF=4194304
        socket = r:SO_SNDBUF=4194304
        TIMEOUTclose = 0
        TIMEOUTidle = 86400
        verifyChain = yes
        checkHost = ://n3pro.home.arpa
        checkIP = 192.168.1.144
      '';
      waitForTarget = pkgs.writeScriptBin "stunnel-wait-for-target" ''
        #!/usr/bin/env sh
        TARGET="n3pro.home.arpa"
        TIMEOUT=120
        INTERVAL=2
        ELAPSED=0
        printf 'Checking connectivity with target: %s\n' "$TARGET"
        while ! nc -z "$TARGET" 443 >/dev/null 2>&1; do
          if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
            echo "Timeout reached!" >&2
            exit 1
          fi
          sleep "$INTERVAL"
          ELAPSED=$((ELAPSED + INTERVAL))
        done
        echo "Target available"
      '';
    in {
      Install.WantedBy = ["default.target"];
      Service = {
        ExecStartPre = "${lib.getExe waitForTarget}";
        ExecStart = "${lib.getExe pkgs.stunnel} ${stunnelConfig}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
        RestartSec = "10";
        Type = "simple";
      };
      Unit = {
        Description = "Stunnel connection with mtls with klipper";
        StartLimitBurst = 5;
        StartLimitIntervalSec = 300;
      };
    };
    xdg.enable = true;
  };
}
