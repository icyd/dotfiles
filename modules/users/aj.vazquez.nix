{lib, ...} @ flakeAttrs: {
  nixpkgs.allowedUnfreePackages = [
    "p4v"
  ];
  flake.meta.users."aj.vazquez" = {
    name = "Alberto Vázquez";
    username = "aj.vazquez";
    email = "aj.vazquez@globant.com";
    host = "ES-IT00385";
  };
  flake.modules.darwin."users/aj.vazquez" = let
    inherit (flakeAttrs.config.flake.meta.users."aj.vazquez") username;
  in {
    system.stateVersion = 4;
    system.primaryUser = username;
  };
  flake.modules.homeManager."users/aj.vazquez" = {
    config,
    pkgs,
    ...
  }: let
    inherit (flakeAttrs.config.flake.meta.users."aj.vazquez") username;
    brewPrefix =
      if pkgs.stdenv.hostPlatform.isAarch64
      then "/opt/homebrew"
      else "/usr/local";
    nixvimPkgs =
      {inherit (pkgs) nixvim nixvimin;}
      |> lib.mapAttrs (_name: value:
        value.extend {
          plugins.luasnip.fromLua = [
            {
              paths = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.lua_snippets.local";
            }
          ];
        });
  in {
    home = {
      stateVersion = "22.05";
      packages = with pkgs;
        [
          awscli2
          crane
          checkov
          conftest
          helm-docs
          helmfile
          keychain
          krew
          kubent
          manifest-tool
          reattach-to-user-namespace
          regclient
          p4v
          podman
          skopeo
          stern
          openssh
          pueue
          trivy
        ]
        ++ [nixvimPkgs.nixvim];
      sessionPath = [
        "$HOME/.krew/bin"
      ];
      sessionVariables = rec {
        MANPATH = "${brewPrefix}/opt/coreutils/libexec/gnuman:$MANPATH";
        PATH = "${brewPrefix}/opt/coreutils/libexec/gnubin:${brewPrefix}/bin:$PATH";
        EDITOR = lib.mkForce (lib.getExe nixvimPkgs.nixvimin);
        VISUAL = EDITOR;
      };
    };
    nushellKeychain = {
      enable = true;
      keys = [
        "id_ed25519"
        "id_ed25519_sk"
      ];
    };
    programs.git = {
      aliases.p4 = "/usr/local/bin/git-p4";
      userName = flakeAttrs.config.flake.meta.users.${username}.name;
      userEmail = flakeAttrs.config.flake.meta.users.${username}.email;
    };
    programs.nushell.extraEnv = ''
      $env.SSH_ASKPASS = "${brewPrefix}/bin/ssh-askpass"
      $env.SSH_ASKPASS_REQUIRE = "prefer"
    '';
    programs.starship.settings.kubernetes.contexts = [
      {
        context_pattern = ".*-prod(?<version>-v[^-]+)?-.*";
        context_alias = "Prod";
        style = "red bold";
      }
      {
        context_pattern = ".*-load(?<version>-v[^-]+)?-.*";
        context_alias = "Load$version";
        style = "orange";
      }
      {
        context_pattern = ".*-nonprod(?<version>-v[^-]+)?-.*";
        context_alias = "Nonprod$version";
        style = "green";
      }
    ];
    imports = with flakeAttrs.config.flake.modules.homeManager; [
      base
      git
      gpg
      nushell
      starship
      zsh
    ];
  };
}
