{
  lib,
  inputs,
  ...
} @ flakeAttrs: {
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
      extraConfig.core.editor = lib.mkForce (lib.getExe nixvimPkgs.nixvimin);
    };
    programs.lazygit = {
      settings.os = let
        nvimin = lib.getExe nixvimPkgs.nixvimin;
      in rec {
        editPreset = lib.mkForce null;
        edit = "${nvimin} {{filename}}";
        editAtLine = "${nvimin} +{{line}} -- {{filename}}";
        editAtLineAndWait = editAtLine;
        openDirInEditor = "${nvimin} -- {{dir}}";
      };
    };
    programs.nushell.extraEnv = ''
      $env.SSH_ASKPASS = "${brewPrefix}/bin/ssh-askpass"
      $env.SSH_ASKPASS_REQUIRE = "prefer"
    '';
    programs.starship.settings.kubernetes.contexts = [
      {
        context_pattern = "^(?<name>[^-]+)-prod(?<version>-v[^-]+)?-.*";
        context_alias = "Prod>$name";
        style = "red bold";
      }
      {
        context_pattern = "^(?<name>[^-]+)-load(?<version>-v[^-]+)?-.*";
        context_alias = "Load>$name$version";
        style = "orange";
      }
      {
        context_pattern = "^(?<name>[^-]+)-(?:nonprod|int)(?<version>-v[^-]+)?-.*";
        context_alias = "Nonprod>$name$version";
        style = "green";
      }
      {
        context_pattern = "^(?<name>[^-]+)-dev(?<version>-v[^-]+)?-.*";
        context_alias = "Dev>$name$version";
        style = "blue";
      }
    ];
    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      defaultSopsFile = "${inputs.nix-secrets.outPath}/work/ES-IT00385.yaml";
      secrets.ssh_private_key.path = "${config.home.homeDirectory}/.ssh/id_ed25519.sops";
    };
    imports = with flakeAttrs.config.flake.modules.homeManager; [
      base
      git
      gpg
      nushell
      starship
      sops
      zsh
    ];
  };
}
