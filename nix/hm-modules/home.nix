{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}: let
  homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/${username}"
    else "/home/${username}";
in {
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
  fonts.fontconfig.enable = true;
  imports = [
    inputs.nix-colors.homeManagerModule
    ./editorconfig.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./nushell.nix
    ./starship.nix
    ../modules/stylix.nix
    ./zsh.nix
  ];
  my.fzf.enable = true;
  home = {
    inherit username homeDirectory;
    stateVersion = "22.05";
    file = {
      ".npmrc".text = ''
        prefix=~/.npm-global
      '';
      ".scripts".source = ../../scripts;
    };
    packages =
      (with pkgs; [
        age-plugin-yubikey
        age-plugin-fido2-hmac
        binutils
        devenv
        devbox
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
        minisign
        mosh
        pandoc
        procs
        rage
        ripgrep
        sd
        sops
        texliveSmall
        yq-go
        yubikey-manager
        zathura
        zenith
      ])
      ++ (with pkgs.nerd-fonts; [
        anonymice
        hack
        inconsolata
        meslo-lg
        sauce-code-pro
      ]);
    sessionPath = [
      "/usr/local/bin"
      "$HOME/.local/bin/"
      "$HOME/.krew/bin"
    ];
    sessionVariables = let
      DOTFILES =
        if pkgs.stdenv.isDarwin
        then "${homeDirectory}/.dotfiles"
        else "/persist/${homeDirectory}/.dotfiles";
      EDITOR = pkgs.lib.getExe pkgs.nixvimin;
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
  };
  programs.bat.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.home-manager.enable = true;
  programs.lazygit = {
    enable = true;
    settings = {
      os = {
        editPreset = "nvim-remote";
      };
    };
  };
  programs.man.generateCaches = true;
  programs.nix-index.enable = true;
  programs.nix-your-shell.enable = true;
  programs.wezterm = {
    enable = true;
    extraConfig = with config.lib.stylix.colors.withHashtag;
      lib.mkMerge [
        ''
          local tab_active_color = "${base0B}"
          local tab_hover_color = "${base0A}"
        ''
        (builtins.readFile ../../wezterm/wezterm.lua)
      ];
  };
  programs.zoxide.enable = true;
  xdg.enable = true;
}
