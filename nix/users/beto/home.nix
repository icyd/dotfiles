{ pkgs, lib, config, username, email, ... }: {
    programs.firefox = {
        enable = true;
        profiles.default = {
            settings = {
                "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
                "media.ffmpeg.vaapi.enabled" = true;
            };
        };
        extensions = with pkgs; [
            nur.repos.rycee.firefox-addons.vimium
            nur.repos.rycee.firefox-addons.gopass-bridge
        ];
    };
    programs.alacritty = import ../../modules/alacritty.nix { inherit config; };
    programs.bat = {
        enable = true;
        config = { theme = "base16"; };
    };
    programs.broot.enable = true;
    programs.fzf = import ../../modules/fzf.nix { inherit lib; };
    programs.git = import ../../modules/git.nix { inherit email; };
    programs.gpg.enable = true;
    programs.home-manager.enable = true;
    programs.tmux = import ../../modules/tmux.nix { inherit lib pkgs; };
    programs.zsh = import ../../modules/zsh.nix { inherit lib pkgs; };
    services = {
        gpg-agent = import ../../modules/services/gpg.nix { pinentryFlavor = "gnome3"; };
        lorri.enable = true;
    };
    xdg.configFile = {
        gammastep.source = ../../../sway/gammastep;
        mako.source = ../../../sway/mako;
        # NOTE: This will allow to modify Neovim configuration <15-12-22, avazquez>
        # nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/nvim";
        nvim.source = ../../../nvim;
        sway.source = ../../../sway/sway;
        swaylock.source = ../../../sway/swaylock;
        waybar.source = ../../../sway/waybar;
        wlogout.source = ../../../sway/wlogout;
        wofi.source = ../../../sway/wofi;
        tmuxp.source = ../../../tmux/tmuxp;
        xkb.source = ../../../xkb;
    };

    home.packages = with pkgs; [
        binutils
        cargo
        cmake
        chromium
        ccls
        dive
        docker
        (pkgs.callPackage ../../modules/go/gig/default.nix {})
        gcc
        gcc-arm-embedded
      # gdb
      glibc
      go_1_18
      gopass
      gopass-jsonapi
      luajit
      luajitPackages.luarocks
      kicad-small
      libreoffice-fresh
      mosh
      openocd
      rustc
      rust-analyzer
      sshfs
      sumneko-lua-language-server
      vifm
  ];

  home.persistence."/mnt/win10/Users/${username}" = {
      directories = [
          "Downloads"
          "Documents"
          "Pictures"
          "Videos"
      ];

      allowOther = false;
  };

  home.persistence."/persist/home/${username}" = {
      directories = [
          {
            directory = ".dotfiles";
            method = "symlink";
          }
          ".local/share/gopass"
          "Backups"
          "Calibre Library"
          "Desktop"
          "Projects"
          "scripts"
      ];

      files = [
          ".wallpaper.jpg"
          ".zsh_history"
      ];

      allowOther = false;
  };
}
