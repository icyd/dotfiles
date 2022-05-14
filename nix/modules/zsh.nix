{ lib, pkgs }: {
    enable = true;
    autocd = true;
    enableAutosuggestions = false;
    enableCompletion = false;
    enableSyntaxHighlighting = false;
    defaultKeymap = "viins";
    dirHashes = {
        docs = "$HOME/Documents";
        dot  = "$HOME/.dotfiles";
        dw   = "$HOME/Downloads";
        ea   = "$HOME/Projects/ea";
        nex  = "$HOME/Nextcloud";
        nix  = "$HOME/.dotfiles/nix";
        pj   = "$HOME/Projects";
    };
    envExtra = ''
        setopt no_global_rcs
        skip_global_compinit=1
        ZSH_DISABLE_COMPFIX="true"
    '';
    history = {
        size = 10000;
    };
    localVariables = {
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
    };
    initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
    '';
    initExtra = ''
      autoload -Uz +X edit-command-line
      autoload -Uz +X zcalc

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
        tmux clear-history
      }
      zle -N clear-scrollback-and-screen
      zle -N edit-command-line

      bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      bindkey -v '^L' clear-scrollback-and-screen
      bindkey '^[[Z' reverse-menu-complete
      bindkey '^E' edit-command-line
      bindkey -M vicmd '!' edit-command-line
      bindkey -s jk '\e'

      mkcd() {
          mkdir -p "$1" && cd "$1" || return 1
      }

      updown() {
        echo $@ | perl -pe 's/(?<![-+\d])(\d+)/+\1/'
      }

      own_pop() {
          popd -q $(updown $@)
      }

      own_push() {
          pushd -q $(updown $@)
      }

      cd_in() {
          cd "$1" && l
      }

      pw(){
        gopass show -C \
          $(gopass ls --flat \
            | fzf -q "$1" --preview "gopass show {}" \
          )
      }

      [ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

      zinit ice depth"1";
      zinit light romkatv/powerlevel10k

      zinit wait lucid light-mode for \
            OMZL::git.zsh \
            OMZP::git \
            mollifier/cd-gitroot \
            chisui/zsh-nix-shell \
            hlissner/zsh-autopair

      zinit as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
        atpull'%atclone' pick"direnv" src"zhook.zsh" for \
            direnv/direnv

      zinit wait lucid light-mode for \
        blockf atpull'zinit creinstall -q .' \
            zsh-users/zsh-completions

      zinit wait lucid light-mode for \
        atinit"zicompinit; zicdreplay" \
            zdharma-continuum/fast-syntax-highlighting \
        atload"_zsh_autosuggest_start" \
            zsh-users/zsh-autosuggestions

      # zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
      #   atpull'%atclone' pick"clrs.zsh" nocompile'!' \
      #   atload'zstyle ":completion:*" list-colors “''${(s.:.)LS_COLORS}”'
      # zinit light trapd00r/LS_COLORS
      # zinit snippet OMZP::colored-man-pages

      zinit wait lucid light-mode for \
        atload'bindkey "^P" history-substring-search-up;
            bindkey "^N" history-substring-search-down;
            bindkey "^Y" autosuggest-accept' \
            zsh-users/zsh-history-substring-search \
        as"completion" \
            OMZP::docker/_docker

      zinit light-mode for \
          pick"zsh-lazyload.zsh" \
              qoomon/zsh-lazyload

      lazyload helm -- 'source <(helm completion zsh)'
      lazyload k -- 'source <(kubectl completion zsh | sed "s/kubectl/k/")'
      lazyload stern -- 'source <(stern --completion=zsh)'
    '' + lib.strings.fileContents ../../zsh/kubectl_aliases.zsh;
    plugins = with pkgs; [
        {
            name = "zinit";
            file = "zinit.zsh";
            src = "${zinit}/share/zinit";
        }
    ];
    profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
    sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
    };
    shellAliases = {
        cat = "bat";
        cdr = "cd-gitroot";
        cl = "clear";
        gpw = "gopass";
        d = "dirs -v";
        dc = "dirs -c";
        p = "own_push";
        o = "own_pop";
        n = "nvr -s";
        s = "nvr -so";
        v = "nvr -sO";
        svim = "sudo -E $EDITOR";
        li = "cd_in";
        lo = "cd .. && l";
        ls = "exa";
        l = "ls -lbF";
        ll = "ls -la";
        llm = "ll --sort=modified";
        la = "ls -lbhHigUmuSa";
        lx = "ls -lbhHigUmuSa@";
        lS = "exa -1";
        k = "kubectl";
        tree = "exa --tree";
    };
    shellGlobalAliases = {
        WC = "| wc -l";
        G = "| grep -i";
        RG = "| rg ";
        X = "| xargs ";
        SED = "| sed -E";
        AWK = "| awk ";
        B64D = "| base64 -d";
    };
}
