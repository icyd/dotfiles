{
  flake.modules.homeManager.zsh = {
    config,
    pkgs,
    ...
  }: let
    envExtraGPG = ''
      # Bind gpg-agent to this TTY if gpg commands are used.
      export GPG_TTY=$(tty)
      # SSH agent protocol doesn't support changing TTYs, so bind the agent
      # to every new TTY.
      ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
    '';
  in {
    home.sessionVariables = with config.xdg; {
      ZSH_CACHE_DIR = "${cacheHome}/zsh";
      ZSH_CONFIG = "${configHome}/zsh";
    };
    programs.zsh = {
      autocd = true;
      enable = true;
      autosuggestion.enable = false;
      enableCompletion = false;
      defaultKeymap = "viins";
      dirHashes = {
        docs = "$HOME/Documents";
        dot = "$DOTFILES";
        dw = "$HOME/Downloads";
        pj = "$HOME/Projects";
        wk = "$HOME/Projects/work";
      };
      dotDir = "${config.xdg.configHome}/zsh";
      envExtra =
        ''
          setopt no_global_rcs
          skip_global_compinit=1
          ZSH_DISABLE_COMPFIX="true"
        ''
        + envExtraGPG;
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      initContent = ''
        autoload -Uz +X edit-command-line
        # autoload -Uz +X zcalc

        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT

        rationalise-dot() {
          if [[ $LBUFFER = *.. ]]; then
            LBUFFER+=/..
          else
            LBUFFER+=.
          fi
        }
        zle -N rationalise-dot
        bindkey . rationalise-dot

        clear-scrollback-and-screen () {
          zle clear-screen
          [ ! -z $TMUX ] && tmux clear-history
        }
        zle -N clear-scrollback-and-screen
        zle -N edit-command-line

        bindkey '^h' backward-delete-char
        bindkey '^k' backward-kill-line
        bindkey '^w' backward-kill-word
        bindkey -v '^L' clear-scrollback-and-screen
        bindkey '^[[Z' reverse-menu-complete
        bindkey '^E' edit-command-line
        bindkey -M vicmd '!' edit-command-line
        bindkey -s jk '\e'

        mkcd() {
            mkdir -p "$1" && cd "$1" || return 1
        }

        [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

        autoload -Uz compinit
      '';
      loginExtra = ''
        {
          # Compile zcompdump, if modified, to increase startup speed.
          zcompdump="$HOME"/.zplug/zcompdump"
          if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
            zcompile "$zcompdump"
          fi
        } &!
      '';
      shellAliases = {
        cdr = "cd-gitroot";
        d = "dirs -v";
        dc = "dirs -c";
      };
      syntaxHighlighting.enable = false;
      zprof.enable = false;
      zplug = {
        enable = true;
        plugins = [
          {name = "mollifier/cd-gitroot";}
          {name = "hlissner/zsh-autopair";}
          {
            name = "zdharma-continuum/fast-syntax-highlighting";
            tags = ["defer:2"];
          }
          {name = "zsh-users/zsh-completions";}
          {
            name = "zsh-users/zsh-history-substring-search";
            tags = [
              ''hook-load:"bindkey '^P' history-substring-search-up; bindkey '^N' history-substring-search-down"''
            ];
          }
          {
            name = "zsh-users/zsh-autosuggestions";
            tags = [''hook-load:"bindkey '^Y' autosuggest-accept"''];
          }
        ];
      };
    };
  };
}
