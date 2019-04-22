#!/usr/bin/env bash
definitions() {
    # Destination for configuration folders
    XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
    export XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
    # Get current working directory
    SCRIPT_PATH="$(cd "$(dirname "$0")"; pwd -P)"
    CWD="$SCRIPT_PATH"
    cd "$CWD"
    # Destination for configuration file
    FILE_DD="${FILE_DD:-$HOME}"
    FOLDER_DD="$XDG_CONFIG_HOME"
    # Script destination
    LOCALBIN_DD="${LOCALBIN_DD:-$HOME/.local/bin}"
    # Pyenv distintation
    PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
    # Pyenv version to use, if not defined use system's version
    command -v "python3" >/dev/null 2>&1
    # type "python3" >/dev/null 2>&1
    if [ "$?" -eq 0 ]; then
        PYTHON="python3"
        PIP="pip3"
    else
        PYTHON="python"
        PIP="pip"
    fi
    SYSTEM_PYTHON_VER="$($PYTHON --version | cut -d ' ' -f2)"
    # Use given python version, otherwise use systems' version
    PYENV_VER=${PYENV_VER:-$SYSTEM_PYTHON_VER}
    # Pyenv virtualenv name
    PYENV_NAME="${PYENV_NAME:-py3neovim}"
    # String to cherrypick files/directories
    SYMLINK_STRING=${SYMLINK_STRING:-"tmux.conf, nvim, zsh, zshenv, zshrc, editorconfig"}
}

usage() {
    definitions
    echo -e "Usage:\n"
    echo -e "\t-c|--create-symlink \"foo, bar\"\tCreate symlinks of the following files/directories"
    echo -e "\t-a|--install-antibody"
    echo -e "\t-tpm|--install-tpm"
    echo -e "\t-vplug|--install-vplug"
    echo -e "\t-fzf|--install-fzf"
    echo -e "\t-pyenv|--install-pyenv"
    echo -e "\t-plugins|--install-vim-plugins"
    echo -e "\t-server|--server-mode"
    echo -e "\t-min|--minimal"
    echo -e "\t-f|--file-destination foo\tDefine where to install files, default: $FILE_DD"
    echo -e "\t-d|--directory-destination bar\tDefine where to install config. directories, default: $FOLDER_DD"
    echo -e "\t-s|--script-destination foobar\tDefine where to install scripts, default: $LOCALBIN_DD"
    echo -e "\t-ph|--pyenv-home\tDefine pyenv home, default: $PYENV_ROOT"
    echo -e "\t-pv|--pyenv-version\tDefine pyenv version, default: System's python version -> $PYENV_VER"
    echo -e "\t-pn|--pyenv-name\tDefine pyenv virtualenv name, default: $PYENV_NAME"
    exit 1
}

# Configuration variables
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -c|--create-symlink)
            CREATE_SYMLINK=1
            SYMLINK_STRING="$2"
            shift
            ;;
        -a|--install-antibody)
            INSTALL_ANTIBODY=1
            ;;
        -tpm|--install-tpm)
            INSTALL_TPM=1
            ;;
        -vplug|--install-vplug)
            INSTALL_VPLUG=1
            ;;
        -fzf|--install-fzf)
            INSTALL_FZF=1
            ;;
        -pyenv|--install-pyenv)
            INSTALL_PYENV=1
            ;;
        -plugins|--install-vim-plugins)
            INSTALL_VIM_PLUGINS=1
            ;;
        -server|--server_mode)
            SERVER_MODE=1
            ;;
        -min|--minimal)
            SKIP_THIS=1
            ;;
        -f|--file-destination)
            FILE_DD="$2"
            shift
            ;;
        -d|--directory-destination)
            XDG_CONFIG_HOME="$2"
            shift
            ;;
        -s|--script-destination)
            LOCALBIN_DD="$2"
            shift
            ;;
        -ph|--pyenv-home)
            PYENV_ROOT="$2"
            shift
            ;;
        -pv|--pyenv_version)
            PYENV_VER="$2"
            shift
            ;;
        -pn|--pyenv_name)
            PYENV_NAME="$2"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            usage
            ;;
    esac
    shift
done

# Confirm function
confirm() {
    # Call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

create_symlinks() {
    [ ! -d "$FOLDER_DD" ] && mkdir -p "$FOLDER_DD"
    [ ! -d "$FILE_DD" ] && mkdir -p "$FILE_DD"
    if [ -z "$SERVER_MODE" ]; then
        readarray -d '' FILES < <(find "${CWD}" -maxdepth 1 -not -name "*.sh" -not -name "README*" -not -name ".git*" -not -path "$CWD" -print0)
    else
        # cherrypick when in server
        FILES=( "${SYMLINK_ARRAY[@]/#/$CWD/}" )
        for ele in "${FILES[@]}"; do
            echo $ele
        done
        exit 1
    fi

    echo -e "${green}Creating symlink for configuration files${reset}"
    for file in "${FILES[@]}"; do
        if [ -f "$file" ]; then
            name="$FILE_DD/.$(basename $file)"
        elif [ -d "$file" ]; then
            name="$FOLDER_DD/$(basename $file)"
        fi

        if [ ! -L "$name" ] && [ -e "$name" ]; then
            echo -e "\t${red}Moving:${reset} ${name} to ${name}.bak"
            mv -f "$name" "${name}.bak"
        fi
        [ -d "$name" ] && name="${name%/*}"

        echo -e "\t${yellow}Creating symlink:${reset} ${name} -> ${file}"
        ln -sf "${file}" "${name}"
    done
    echo -e "\n"
}

# Install antibody
install_antibody() {
    INSTALL_PATH="$FOLDER_DD/zsh"
    if [ ! -f "$INSTALL_PATH/antibody" ]; then
        TMPDIR=$(mktemp -d)
        LINK=$(curl -s https://api.github.com/repos/getantibody/antibody/releases/latest | egrep browser_download_url.*$(uname -s)_$(uname -m) | perl -lne 'print $1 if /(http.*)"/i')
        echo -e "${green}Installing antibody into:${reset} $INSTALL_PATH"
        curl -sLo /tmp/antibody.tar.gz "$LINK"
        tar -xf /tmp/antibody.tar.gz -C "$TMPDIR"
        [ ! -d "$INTALL_PATH" ] && mkdir -p "$INSTALL_PATH"
        mv -f "$TMPDIR/antibody" "$INSTALL_PATH"
        chmod +x "$INSTALL_PATH/antibody"
    else
        echo -e "${green}Antibody already installed${reset}"
    fi
    echo -e "\n"
}


# Install fzf
install_fzf() {
    INSTALL_PATH="$FOLDER_DD/fzf"
    if [ ! -d "$INSTALL_PATH" ]; then
        echo -e "${yellow}Downloading fzf into:${reset} $INSTALL_PATH"
        git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_PATH"
        bash "$INSTALL_PATH"/install --xdg --no-fish --no-bash --key-bindings --completion --64 --update-rc
    else
        echo -e "${green}fzf already installed.${reset}"
    fi
    echo -e "\n"
}

# Install tpm
install_tpm() {
    INSTALL_PATH="$FOLDER_DD/tmux/plugins/tpm"
    if [ ! -d "$INSTALL_PATH" ]; then
        [ ! -d "${INSTALL_PATH%/*}" ] && mkdir -p "${INSTALL_PATH%/*}"
        echo -e "${yellow}Downloading tpm into:${reset} $INSTALL_PATH"
        git clone -q https://github.com/tmux-plugins/tpm $INSTALL_PATH > /dev/null
    else
        echo -e "${green}tpm already installed.${reset}"
    fi
    echo -e "\n"
}

# Install Vim-plug
install_vplug() {
    INSTALL_PATH="$FOLDER_DD/nvim/autoload/plug.vim"
    if [ ! -f "$INSTALL_PATH" ]; then
        echo -e "${yellow}Downloading plug.vim into:${reset} $INSTALL_PATH"
        curl -fLo "$INSTALL_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null
    else
        echo -e "${green}plug.vim already installed${reset}"
    fi
    echo -e "\n"
}

# Installing plugins
install_vim_plugins() {
    if [ -f "$FOLDER_DD/nvim/config/plugins.vim" ]; then
        TMP=$(mktemp)
        echo -e "${yellow}Creating base configuration for installing Neovim's pluggins in:${reset} $TMP"
        sed '/^\s*call\splug\#end\(\)/q' "$FOLDER_DD/nvim/config/plugins.vim" > "$TMP"
        [ -n "$SERVER_MODE" ] && sed -i -e '/^"#IGNORE/,/^"#ENDIGNORE/d' "$TMP"
        echo -e "${yellow}Installing pluggins...${reset}"
        nvim -u "$TMP" -c 'PlugInstall! | qa!'
    fi
    echo -e "\n"
}

# Installing thesaur
install_vim_thesaur() {
    if [ ! -f "${FOLDER_DD}/nvim/thesaurus/mthesaur.txt" ]; then
        echo -e "${yellow}Downloading mthesaur.txt into:${reset} ${FOLDER_DD}/nvim/thesaurus/mthesaur.txt"
        curl -sfLo "${FOLDER_DD}/nvim/thesaurus/mthesaur.txt" --create-dirs \
            http://www.gutenberg.org/files/3202/files/mthesaur.txt 2>/dev/null
    else
        echo -e "${green}thesaur already installed.${reset}"
    fi
    echo -e "\n"
}

# Generate nvim config for server
server_vim_config() {
    if [ -f "${FOLDER_DD}/nvim/config/plugins.vim" ]; then
        echo -e "${yellow}Generating vim configuration file for server:${reset} ${FOLDER_DD}/nvim/config/plug_server.vim"
        sed -e '/^"#IGNORE/,/^"#ENDIGNORE/d' "${FOLDER_DD}/nvim/config/plugins.vim" > "${FOLDER_DD}/nvim/config/plug_server.vim"
    fi
    echo -e "\n"
}

install_pyenv() {
    command -v pyenv >/dev/null 2>&1
    if [ ! -f "$PYENV_ROOT/bin/pyenv" ]; then
        echo -e "${yellow}Installing pyenv${reset}"
        curl -sL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash >/dev/null 2>&1
    else
        echo -e "${green}Pyenv already installed${reset}"
    fi
    export PATH="${PYENV_ROOT}/bin:$PATH"
    PYTHON=$(pyenv which python)
    echo -e "${yellow}Using python version:${reset} $PYENV_VER"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv virtualenvs | egrep -w "$PYENV_NAME" >/dev/null
    if [ "$?" -ne 0 ]; then
        echo -e "${yellow}Installing python virtualenv:${reset} $PYENV_NAME"
        pyenv versions | egrep -w "$PYENV_VER" >/dev/null
        if [ "$?" -ne 0 ]; then
            echo -e "${yellow}Installing python version:${reset} $PYENV_VER"
            pyenv install "$PYENV_VER" >/dev/null
        else
            echo -e "${green}Python version already installed:${reset} $PYENV_VER"
        fi
        pyenv virtualenv "$PYENV_VER" "$PYENV_NAME" >/dev/null
    else
        echo -e "${green}Pyenv virtualenv already exist:${reset} $PYENV_NAME"
    fi
    pyenv activate "$PYENV_NAME"
    PYTHON=$(pyenv which python)
    echo -e "\n${yellow}Updating pip${reset}"
    pip install -q -U pip
    echo -e "${yellow}Installing python packages.${reset}"
    if [ -z "$SERVER_MODE" ]; then
        pip install -r "${CWD}/nvim/requirements.txt" >/dev/null
        echo -e "${yellow}Installing node.js.${reset}"
        nodeenv -p > /dev/null
        echo -e "${yellow}Installing node.js packages.${reset}"
        NPM="$(pyenv which npm)"
        cat "${CWD}/nvim/npm_requirements.txt" | xargs $NPM -g install >/dev/null
    else
        echo -e "${yellow}Installing pynvim${reset}"
        pip -q install -U pynvim
        echo -e "${yellow}Installing neovim${reset}"
        pip -q install -U neovim
        echo -e "${yellow}Installing neovim-remote${reset}"
        pip -q install -U neovim-remote
    fi

    echo -e "${yellow}Substituying python path in the configuration file: ${reset} ${PYTHON}"
    sed -i -e "s!\(^\s*let\sg:python3_host_prog\s=\s\).*!\1'${PYTHON}'!" "${FOLDER_DD}/nvim/init.vim"
    sed -i -e "s!\(^\s*let\s\$PATH\s=\s\).*!\1'${PYTHON%/*}/'\.\$PATH!" "${FOLDER_DD}/nvim/init.vim"

    echo -e "${yellow}Updating Nvim'- remote plugins${reset}"
    nvim -c 'UpdateRemotePlugins | qa!'

    echo -e "${yellow}Creating Symlink to NVR${reset}"
    [ ! -d "$LOCALBIN_DD" ] && mkdir -p "$LOCALBIN_DD"
    ln -sf "${PYTHON%/*}/nvr" "$LOCALBIN_DD/nvr"
    echo -e "\n"
}

main() {
    definitions
    IFS=", " read -r -a SYMLINK_ARRAY <<< "$SYMLINK_STRING"

    red=`tput setaf 1`
    green=`tput setaf 2`
    yellow=`tput setaf 3`
    blue=`tput setaf 4`
    magenta=`tput setaf 5`
    reset=`tput sgr0`


    [ -n "$CREATE_SYMLINK" ] && create_symlinks
    [ -n "$INSTALL_ANTIBODY" ] && install_antibody
    [ -n "$INSTALL_TPM" ] && install_tpm
    [ -n "$INSTALL_VPLUG" ] && install_vplug
    [ -n "$INSTALL_FZF" ] && install_fzf
    [ -n "$INSTALL_PYENV" ] && install_pyenv
    if [ -n "$INSTALL_VIM_PLUGINS" ]; then
        install_vim_plugins
        if [ -n "$SERVER_MODE" ]; then
            server_vim_config
            echo -e "export SERVER_MODE=1" > "$FOLDER_DD/zsh/local.zsh"
        else
            install_vim_thesaur
        fi
    fi
    [ -n "$SKIP_THIS" ] && echo -e "export SKIP_THIS=1" >> "$FOLDER_DD/zsh/local.zsh"
    echo $SERVER_MODE
    echo -e "${green}DONE!${reset}"
}
main
exit 0
