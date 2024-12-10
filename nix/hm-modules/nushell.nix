{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.carapace.enable = true;
  programs.nushell = {
    enable = true;
    package = pkgs.unstable.nushell;
    shellAliases = {
      "~docs" = ''cd $"($env.HOME)/Documents"'';
      "~dot" = ''cd $env.DOTFILES'';
      "~drop" = ''cd $"($env.HOME)/Dropbox"'';
      "~org" = ''cd $"($env.HOME)/Dropbox/org"'';
      "~work" = ''cd $"($env.HOME)/Dropbox/org/work"'';
      "~dw" = ''cd $"($env.HOME)/Downloads"'';
      "~ea" = ''cd $"($env.HOME)/Projects/ea"'';
      "~nex" = ''cd $"($env.HOME)/Nextcloud"'';
      "~nix" = ''cd $"($env.HOME)/.dotfiles/nix"'';
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
    configFile.text =
      with lib;
      mkMerge [
        (concatStringsSep "\n" (
          mapAttrsToList (k: v: ''let ${toLower k} = "#${v}"'') config.colorScheme.palette
        ))

        (builtins.readFile ../../nushell/config.nu)
      ];
    envFile.source = ../../nushell/env.nu;
    extraConfig = ''
      use utils.nu
      use certs.nu
      use modules/background_task/task.nu
      use kubernetes.nu *
      use ~/.local.nu *
      use git-gone.nu *
      use cd-root.nu *
    '';
  };
}
