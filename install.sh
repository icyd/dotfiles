#!/usr/bin/env bash

# Current working directory
SCRIPT_PATH="$(readlink -e "$0")"
CWD="$(dirname "$SCRIPT_PATH")"
cd "$CWD"
# Destination for configuration file
FILE_DD="$HOME"
# Destination for configuration folders
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CONFIG_HOME="$XDG_CONFIG_HOME"
export SERVER="$SERVER"
FOLDER_DD="$XDG_CONFIG_HOME"
FOLDER_DD="$XDG_CONFIG_HOME"
# Script destination
LOCALBIN_DD="${LOCALBIN_DD:-$HOME/.local/bin}"
# Pyenv distintation
PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
# Pyenv version to use, if not defined use system's version
if [ $(command -v python3) ]; then
	PYTHON="python3"
else
	PYTHON="python"
fi
SYSTEM_PYTHON_VER="$($PYTHON --version | cut -d ' ' -f2)"
PYENV_VER=${PYENV_VER:-$SYSTEM_PYTHON_VER}
# Pyenv virtualenv name
PYENV_NAME="${PYENV_NAME:-py3neovim}"

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
reset=`tput sgr0`

# Confirm function
confirm() {
    # call with a prompt string or use a default
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
    if [ -z "$SERVER" ]; then
        readarray -d '' FILES < <(find "${CWD}" -maxdepth 1 -not -name "*.sh" -not -name "README*" -not -name ".git*" -not -path "$CWD" -print0)
    else
        # cherrypick when in server
        FILES=(tmux.conf nvim zsh zshenv zshrc)
        FILES=( "${FILES[@]/#/$CWD/}" )
    fi

    echo -e "${green}Creating symlink for configuration files${reset}"
    for file in "${FILES[@]}"; do
        if [ -f "$file" ]; then
            name="$FILE_DD/.$(basename $file)"
        elif [ -d "$file" ]; then
            name="$FOLDER_DD/$(basename $file)"
        fi

        [ $(basename $file) == "rofi-ico-finder" ] && continue
        [ $(basename $file) == "scripts" ] && continue
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
        [ -n "$SERVER" ] && sed -i -e '/^"IGNORE/,/^"END_IGNORE/d' "$TMP"
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
        sed -e '/^"IGNORE/,/^"END_IGNORE/d' "${FOLDER_DD}/nvim/config/plugins.vim" > "${FOLDER_DD}/nvim/config/plug_server.vim"
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
    pyenv virtualenvs | egrep -w "$PYENV_NAME\$" >/dev/null
    if [ "$?" -eq 0 ]; then
        echo -e "${yellow}Installing python virtualenv:${reset} $PYENV_NAME"
        pyenv versions | egrep -w "$PYENV_VER\$" >/dev/null
        if [ "$?" -ne 0 ]; then
            echo -e "${yellow}Installing python version:${reset} $PYENV_VER"
            pyenv install "$PYENV_VER"
        else
            echo -e "${green}Python version already installed:${reset} $PYENV_VER"
        fi
        pyenv virtualenv "$PYENV_VER" "$PYENV_NAME" >/dev/null 2>&1
    else
        echo -e "${green}Pyenv virtualenv already exist:${reset} $PYENV_NAME"
    fi
    pyenv activate "$PYENV_NAME"
    PYTHON=$(pyenv which python)
    echo -e "\n${yellow}Updating pip${reset}"
    pip install -q -U pip
    echo -e "${yellow}Installing python packages.${reset}"
    if [ -z "$SERVER" ]; then
        pip install -r "${CWD}/nvim/requirements.txt"
        echo -e "${yellow}Installing node.js.${reset}"
        nodeenv -p
        echo -e "${yellow}Installing node.js packages.${reset}"
        cat "${CWD}/nvim/npm_requirements.txt" | xargs npm -g install
    else
        echo -e "${yellow}Installing pynvim${reset}"
        pip -q install -U pynvim
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
    cat "${FILE_DD}/.zshenv" | egrep "PATH" | egrep "$LOCALBIN_DD" >/dev/null
    if [ "$?" -ne 0 ]; then
        echo -e "${yellow}Appending nvr path to paths in:${reset} ${FILE_DD}/.zshenv"
        sed -i -e "/^export\sPATH.*/ a export\ PATH=\"${LOCALBIN_DD}:\$PATH\"" "${CWD}/zshenv"
    fi
    echo -e "\n"
}

create_symlinks
install_antibody
install_tpm
install_vplug
if [ -n "$SERVER" ]; then
    server_vim_config
else
    install_vim_thesaur
fi
install_vim_plugins
install_pyenv
install_fzf
echo -e "${green}DONE!${reset}"
