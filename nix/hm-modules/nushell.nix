{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.carapace.enable = true;
  programs.nushell = let
    buf_editor = pkgs.lib.getExe pkgs.nixvimin;
  in {
    enable = true;
    shellAliases = {
      "~docs" = ''cd $"($env.HOME)/Documents"'';
      "~dot" = ''cd $env.DOTFILES'';
      "~drop" = ''cd $"($env.HOME)/Dropbox"'';
      "~dw" = ''cd $"($env.HOME)/Downloads"'';
      "~wk" = ''cd $"($env.HOME)/Projects/work"'';
      "~pj" = ''cd $"($env.HOME)/Projects"'';
      a = "enter";
      b64d = "base64 -d";
      cat = "bat";
      cl = "clear";
      cby = "clipboard copy";
      cbp = "clipboard paste";
      d = "shells";
      fj = "from json";
      fy = "from yaml";
      g = "git";
      gi = "git";
      gig = "utils gitignore_template";
      gpw = "gopass";
      jat = "bat -ljson";
      k = "kubectl";
      l = "eza";
      l1 = "eza -1";
      lb = "eza -lb";
      ll = "eza -la";
      llm = "eza -la --sort=modified";
      lx = "eza -lbhHigUmuSa@";
      la = "eza -lbhHigUmuSa";
      lg = "lazygit";
      nv = "nvim_client";
      nvr = "nvim_server";
      pw = "gopass show -c";
      svim = "sudo -E $env.EDITOR";
      tcp = "utils trimcopy";
      tj = "to json";
      tree = "eza --tree";
      ty = "to yaml";
      yat = "bat -lyaml";
      xat = "bat -lxml";
      zj = "zellij";
      zr = "zellij-runner";
      xssh = "TERM=xterm-256color ssh";
    };
    configFile.text = with config.lib.stylix.colors.withHashtag;
      lib.mkMerge [
        ''
          let menu_style = {
              text: "${base06}"
              selected_text: {fg: "${base0D}" attr: b}
              description_text: "${base04}"
          }
          let buf_editor = "${buf_editor}"
        ''

        (builtins.readFile ../../nushell/config.nu)
      ];
    envFile.source = ../../nushell/env.nu;
    extraConfig = ''
      use std/log
      use utils.nu
      use certs.nu
      use modules/background_task/task.nu
      use kubernetes.nu *
      use ~/.local.nu *
      use git-gone.nu *
      use cd-root.nu *
      use ${pkgs.bash-env-nushell}/bash-env.nu

      def --wrapped --env devbox_refresh [
        --global (-g)
        ...args
      ] {
        let devbox = if ($global) {
          devbox global shellenv --pure ...$args
        } else {
          devbox shellenv --pure ...$args
        } | bash-env

        $devbox | reject "PATH" | load-env
        $env.PATH = (["/run/current-system/sw/bin" "${config.home.homeDirectory}/.nix-profile/bin" ]
          ++ ($devbox.PATH | split row (char esep)) ++ $env.PATH)
          | uniq
      }

      if (not ("DEVBOX_PURE_SHELL" in ($env | columns))) {
        devbox_refresh --global
      }
    '';
  };
}
