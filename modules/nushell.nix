{
  flake.modules.homeManager.nushell = {
    lib,
    config,
    pkgs,
    ...
  }: {
    programs.carapace = {
      enable = true;
      package = pkgs.mv.tip.carapace;
    };
    programs.nushell = let
      buf_editor = pkgs.lib.getExe pkgs.nixvimin;
    in {
      enable = true;
      package = pkgs.mv.tip.nushell;
      plugins = with pkgs.mv.tip.nushellPlugins; [
        hcl
        # (hcl.overrideAttrs (prev: rec {
        #   version = "git";
        #   src = pkgs.fetchFromGitHub {
        #     inherit (prev.src) owner repo;
        #     tag = "0.115.0";
        #     hash = "sha256-F/JYk9dvxii3EzWr4WlrJxJvZ5rQwIFcG8KW28SpsGA=";
        #   };
        #   cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        #     inherit src;
        #     hash = "sha256-qpIREWBy6hX5svk0SEQUeZe0HvNa11E6sh6QtS4mMCs=";
        #   };
        #   doCheck = false;
        #   doInstallCheck = false;
        # }))
      ];
      shellAliases = {
        "~docs" = ''cd $"($env.HOME)/Documents"'';
        "~dot" = ''cd $env.DOTFILES'';
        "~drop" = ''cd $"($env.HOME)/Dropbox"'';
        "~dw" = ''cd $"($env.HOME)/Downloads"'';
        "~wk" = ''cd $"($env.HOME)/Projects/work"'';
        "~pj" = ''cd $"($env.HOME)/Projects"'';
        fj = "from json";
        fy = "from yaml";
        gig = "utils gitignore_template";
        "," = "mvs run";
        ",s" = "_run_in_nu mvs shell";
        mvss = "_run_in_nu mvs shell";
        ",v" = "mvs query versions";
        tcp = "utils trimcopy";
        tj = "to json";
        ty = "to yaml";
      };
      configFile.text =
        lib.optional (config.lib.stylix ? colors) (with config.lib.stylix.colors.withHashtag; ''
          let menu_style = {
              text: "${base06}"
              selected_text: {fg: "${base0D}" attr: b}
              description_text: "${base04}"
          }
          let buf_editor = "${buf_editor}"
        '')
        ++ [
          (builtins.readFile ../config/nushell/config.nu)
        ]
        |> lib.mkMerge;
      envFile.source = ../config/nushell/env.nu;
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
      '';
    };
  };
}
