#!/usr/bin/env bash
# Check requirements
VIM="$(which nvim 2>/dev/null || which vim 2>/dev/null)"
if [ ! -x "$VIM" ]; then
    echo -e "${red}nvim nor vim is installed, exiting${reset}"
    exit 255
fi

CURL=$(which curl 2>/dev/null)
if [ ! -x "$CURL" ]; then
    echo -e "${red}curl not installed exiting${reset}"
    exit 255
fi

STOW=$(which stow 2>/dev/null)
if [ ! -x "$STOW" ]; then
    echo -e "${red}stow not installed exiting${reset}"
    exit 255
fi

EXCLUDE="${EXCLUDE:-\"Microsoft Terminal\"}"

# Functions definitions
usage() {
    echo -e "Usage:\n"
    echo -e "\t-c|--create-symlink\tCreate symlinks of the files/directories inside the repository."
    echo -e "\t-a|--install-antibody"
    echo -e "\t-tpm|--install-tpm"
    echo -e "\t-paq|--install-paq"
    echo -e "\t-lua-plugins|--install-lua-plugins"
    echo -e "\t-fzf|--install-fzf"
    echo -e "\t-light|--light-version"
    echo -e "\t-thesaurus|--install-vim-thesaurus"
    echo -e "\t--remove-symlink"
    exit 1
}

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

remove_symlinks() {
    pushd $CWD >/dev/null
    echo -e "${green}Removing previous symlinks${reset}"
    find * -maxdepth 0 -type d -exec $STOW -D {} \;
    popd >/dev/null
}

create_symlinks() {
    EXCLUDE="${1:-$EXCLUDE}"
    remove_symlinks
    pushd $CWD >/dev/null
    PATH_EXCLUDED=$(echo -n $EXCLUDE | tr ',' '\0' | xargs -0 -I{} printf '-path {} -o ' | sed 's/-o\s$//')
    echo -e "${green}Creating symlink for configuration files${reset}"
    echo -n "-not \( $PATH_EXCLUDED -prune \)" | xargs find * -maxdepth 0 -type d | xargs -L1 $STOW -S
    popd >/dev/null

    case $(uname -s) in
        Darwin)
            echo -e "${green}Using gpg-agent.conf for Dawin${reset}"
            ln -sf $GNUPGHOME/gpg-agent.darwin.conf $GNUPGHOME/gpg-agent.conf
            ;;
        Linux)
            echo -e "${green}Using gpg-agent.conf for Linux${reset}"
            ln -sf $GNUPGHOME/gpg-agent.linux.conf $GNUPGHOME/gpg-agent.conf
            ;;
        *)
            echo -e "${yellow}Unknown system, skipping${reset}"
            ;;
    esac

    echo -e "${green}Changing permissions to gnupg folder${reset}"
    find $GNUPGHOME -type d -exec chmod 700 {} \;
    find $GNUPGHOME -type f -exec chmod 600 {} \;
    echo -e "\n"
}

# Install antibody
install_antibody() {
    INSTALL_PATH="$HOME/.local/bin"
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
    INSTALL_PATH="$XDG_CONFIG_HOME/fzf"
    if [ ! -d "$INSTALL_PATH" ]; then
        echo -e "${yellow}Downloading fzf into:${reset} $INSTALL_PATH"
        git clone --depth 1 https://github.com/junegunn/fzf.git "$INSTALL_PATH"
        bash "$INSTALL_PATH"/install --xdg --no-zsh --no-fish --no-bash --key-bindings --completion --no-update-rc
    else
        echo -e "${green}fzf already installed.${reset}"
    fi
    echo -e "\n"
}

# Install tpm
install_tpm() {
    INSTALL_PATH="$XDG_CONFIG_HOME/tmux/plugins/tpm"
    if [ ! -d "$INSTALL_PATH" ]; then
        [ ! -d "${INSTALL_PATH%/*}" ] && mkdir -p "${INSTALL_PATH%/*}"
        echo -e "${yellow}Downloading tpm into:${reset} $INSTALL_PATH"
        git clone -q https://github.com/tmux-plugins/tpm $INSTALL_PATH > /dev/null
    else
        echo -e "${green}tpm already installed.${reset}"
    fi
    echo -e "\n"
}

# Install paq-nvim
install_paq() {
    INSTALL_PATH="$XDG_DATA_HOME/nvim/site/pack/paqs/start/paq-nvim"
    if [ ! -d "$INSTALL_PATH" ]; then
        echo -e "${yellow}Downloading paq-nvim into:${reset} $INSTALL_PATH"
        git clone --depth=1 https://github.com/savq/paq-nvim.git \
        $INSTALL_PATH
    else
        echo -e "${green}paq-nvim already installed${reset}"
    fi
    echo -e "\n"
}

# Installing lua plugins
install_lua_plugins() {
    PLUGINS_FILE="$CWD/nvim/.config/nvim/lua/plugins.lua"
    if [ -f "$PLUGINS_FILE" ]; then
        TMP=$(mktemp)
        echo -e "${yellow}Creating base configuration for installing Neovim's pluggins in:${reset} $TMP"
        cat<<EOF > "$TMP"
lua <<EOL
vim.cmd[[packadd paq-nvim]]
local paq = require('paq-nvim').paq
EOF
        sed -n '/^\s*paq.*/p' "$PLUGINS_FILE" >> "$TMP"
        echo "EOL" >> "$TMP"
        echo -e "${yellow}Installing pluggins...${reset}"
        "$VIM" -u "$TMP" -c 'PaqInstall'
    fi
    echo -e "\n"
}

# Installing thesaur
install_vim_thesaurus() {
    THESAURUS_FILE="$XDG_DATA_HOME/nvim/thesaurus/mthesaur.txt"
    if [ ! -f "$THESAURUS_FILE" ]; then
        echo -e "${yellow}Downloading mthesaur.txt into:${reset} $THESAURUS_FILE"
        curl -sfLo "$THESAURUS_FILE" --create-dirs \
            http://www.gutenberg.org/files/3202/files/mthesaur.txt 2>/dev/null
    else
        echo -e "${green}Thesaurus file already installed.${reset}"
    fi
    echo -e "\n"
}

# Installing asdf
install_asdf() {
    ASDF_VERSION="${ASDF_VERSION:-v0.8.1}"
    ASDF_DIR="$HOME/.asdf"
    if [ ! -d "$ASDF_DIR" ]; then
        echo -e "${yellow}Downloading asdf ($ASDF_VERSION) into:${reset} $ASDF_DIR"
        git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch $ASDF_VERSION
    else
        echo -e "${green}Asdf already installed.${reset}"
    fi
    echo -e "\n"
}

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
reset=`tput sgr0`

# Get current working directory
CWD="$(cd "$(dirname "$0")"; pwd -P)"
source $CWD/zsh/.zshenv

# Configuration variables
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        -c|--create-symlink)
            create_symlinks
            ;;
        -a|--install-antibody)
            install_antibody
            ;;
        -tpm|--install-tpm)
            install_tpm
            ;;
        -paq|--install-paq)
            install_paq
            ;;
        -lua-plugins|--install-lua-plugins)
            install_lua_plugins
            ;;
        -fzf|--install-fzf)
            install_fzf
            ;;
        -light|--light-version)
            install_tpm
            install_paq
            install_fzf
            install_lua_plugins
            install_asdf
            create_symlinks '"Microsoft Terminal\",sway,xkb'
            install_antibody
            ;;
        -thesaurus|--install-vim-thesaurus)
            install_vim_thesaurus
            ;;
        -asdf|--install-asdf)
            install_asdf
            ;;
        --remove-symlink)
            remove_symlinks
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

echo -e "${green}DONE!${reset}"
exit 0
