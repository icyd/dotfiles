{ lib, pkgs, config, gpgInit ? true }:
let
  envExtraGPG = if !gpgInit then
    ""
  else ''
    # Bind gpg-agent to this TTY if gpg commands are used.
    export GPG_TTY=$(tty)
    # SSH agent protocol doesn't support changing TTYs, so bind the agent
    # to every new TTY.
    ${pkgs.gnupg}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
    export SSH_AUTH_SOCK=$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)
  '';
in {
  autocd = true;
  enable = true;
  enableAutosuggestions = false;
  enableCompletion = false;
  defaultKeymap = "viins";
  dirHashes = {
    docs = "$HOME/Documents";
    dot = "$HOME/.dotfiles";
    dw = "$HOME/Downloads";
    ea = "$HOME/Projects/ea";
    nex = "$HOME/Nextcloud";
    drop = "$HOME/Dropbox";
    nix = "$HOME/.dotfiles/nix";
    pj = "$HOME/Projects";
  };
  envExtra = ''
    setopt no_global_rcs
    skip_global_compinit=1
    ZSH_DISABLE_COMPFIX="true"
  '' + envExtraGPG;
  history = { size = 10000; };
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

    kcx(){ [ $# -ge 1 ] && kubectl ctx $1 || kubectl ctx $(kubectl ctx | fzf --preview={} --preview-window=:hidden)  }

    kns(){ [ $# -ge 1 ] && kubectl ns $1 || kubectl ns $(kubectl ns | fzf --preview={} --preview-window=:hidden)  }

    tmuxp_fzf() {
        tmuxp load $(tmuxp ls | fzf --reverse --border --no-preview --height=10%)
    }

    tls_cert_key_verify() {
        CERT_MD5=$(openssl x509 -noout -modulus -in "$1" | openssl md5)
        KEY_MD5=$(openssl rsa -noout -modulus -in "$2" | openssl md5)
        [ "$CERT_MD5" = "$KEY_MD5" ] && echo "OK" || echo "ERROR"
    }

    tls_cert_text() {
        openssl x509 -noout -text -in "$@"
    }

    tls_key_text() {
        openssl rsa -noout -text -in "$@"
    }

    nvim_client() {
      OPTS="''${@:1:$((#-1))}"
      FILE="''${@:$#}"
      nvim --server "$NVIM_SERVER" "$OPTS" "$(readlink -qm "$FILE")"
    }

    # [ -f "$HOME/.p10k.zsh" ] && source "$HOME/.p10k.zsh"
    [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

    zpcompdef g='git'
    autoload -Uz _zinit
    (( ''${+_comps} )) && _comps[zinit]=_zinit

    # zinit light-mode for \
      # depth"1" \
      #  romkatv/powerlevel10k \
    zinit light-mode for \
      pick"zsh-lazyload.zsh" \
          qoomon/zsh-lazyload
      # as"command" from"gh-r" \
      #   atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
      #   atpull"%atclone" src"init.zsh" \
      # #     starship/starship \

    zinit wait lucid light-mode for \
          mollifier/cd-gitroot \
          chisui/zsh-nix-shell \
          hlissner/zsh-autopair \
          OMZP::aws \
      as"completion" \
          OMZP::docker/_docker \
      atload'bindkey "^P" history-substring-search-up; \
          bindkey "^N" history-substring-search-down' \
          zsh-users/zsh-history-substring-search \
      atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
          zdharma-continuum/fast-syntax-highlighting \
      atload'_zsh_autosuggest_start; \
          bindkey "^Y" autosuggest-accept' \
          zsh-users/zsh-autosuggestions
      # blockf atpull'zinit creinstall -q .' \
      #     zsh-users/zsh-completions

    lazyload helm -- 'source <(helm completion zsh)'
    lazyload stern -- 'source <(stern --completion=zsh)'
    lazyload k -- 'source <(kubectl completion zsh | sed "s/kubectl/k/")'

    [ -f "$HOME/.k8s_aliases.zsh" ] && source "$HOME/.k8s_aliases.zsh"
  '';
  initExtraFirst = ''
    if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
  '';
  localVariables = { POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true; };

  plugins = with pkgs; [{
    file = "zinit.zsh";
    name = "zinit";
    src = "${zinit}/share/zinit";
  }];
  profileExtra = ''
    # if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
    #   exec sway
    # fi
  '';
  shellAliases = {
    cat = "bat";
    cdr = "cd-gitroot";
    cl = "clear";
    d = "dirs -v";
    dc = "dirs -c";
    gi = "git";
    gpw = "gopass";
    k = "kubectl";
    krrdep = "kubectl rollout restart deployment";
    krrds = "kubectl rollout restart daemonset";
    krrsts = "kubectl rollout restart statefulset";
    l = "exa";
    l1 = "exa -1";
    lb = "exa -lb";
    ll = "exa -la";
    llm = "exa -la --sort=modified";
    lx = "exa -lbhHigUmuSa@";
    la = "exa -lbhHigUmuSa";
    n = "nvim_client --remote-silent";
    nt = "nvim_client --remote-tab-silent";
    nvr = "nvim --listen $NVIM_SERVER";
    o = "own_pop";
    p = "own_push";
    svim = "sudo -E $EDITOR";
    tree = "exa --tree";
    tx = "tmuxp_fzf";
    zj = "zellij";
    zr = "zellij-runner";
  };
  shellGlobalAliases = {
    AWK = "| awk ";
    B64D = "| base64 -d";
    G = "| grep -i";
    J = " | jq";
    KN = " -oyaml | kubectl neat";
    RG = "| rg ";
    SED = "| sed -E";
    T = "| tee ";
    WC = "| wc -l";
    Y = " | yq";
    YN = " -oyaml | kubectl neat | yq";
    X = "| xargs ";
  };
  syntaxHighlighting.enable = false;
}
