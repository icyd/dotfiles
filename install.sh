#!/usr/bin/env bash

# Current working directory
CWD=$(pwd)
# Destination for configuration file
FILE_DD=$HOME
# Destination for configuration folders
FOLDER_DD=$HOME/.config

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

echo -e "${yellow}Creating symlink for configuration files:"
# Create symlink for configuration files
find "${CWD}" -maxdepth 1 -type f -not \( -name "*.sh" -o -name "README.md" -o -name ".gitignore" \) -print |
    while read file; do
        name="${FILE_DD}/.$(basename $file)"

        if [ -f "$name" ] && [ ! -L "$name" ]; then
            echo -e "\t${red}Moving:${reset} ${name} to ${name}.bak"
            mv -f "$name" "${name}.bak"
        fi
        echo -e "\t${green}Creating symlink:${reset} ${name} -> ${file}"
        ln -sf "${file}" "${name}"
    done

find "${CWD}" -maxdepth 1 -type d -not \( -name ".git" -o -path "${CWD}" \) -print |
    while read file; do
        name="${FOLDER_DD}/$(basename $file)"

        if [ -d "$name" ] && [ ! -L "$name" ]; then
            echo -e "\t${red}Erasing symlink: ${reset}${name}"
            rm -f "${name}"
        fi
        echo -e "\t${green}Creating symlink:${reset} ${name} -> ${file}"
        ln -sf "${file}" "${name}"
    done

echo -e "\n"

# Install Vim-plug
if [ ! -f "${FOLDER_DD}/nvim/autoload/plug.vim" ]; then
    echo -e"${yellow}Downloading plug.vim into:${reset} ${FOLDER_DD}/nvim/autoload/"
    curl -fLo "${FOLDER_DD}/nvim/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo -e "\n"

# Installing plugins
echo -e "${yellow}Creating base configuration for installing Neovim's pluggins in:${reset} /tmp/tmp.vimrc"
sed '/^\s*call\splug\#end\(\)/q' "${FOLDER_DD}/nvim/config/plugins.vimrc" > /tmp/tmp.vimrc
echo -e "\n${yellow}Installing pluggins...${reset}"
nvim -u /tmp/tmp.vimrc -c 'PlugInstall! | qa!'

echo -e "\n"

# Installing thesaur
if [ ! -f "${FOLDER_DD}/nvim/thesaurus/mthesaur.txt" ]; then
    echo -e "${yellow}Downloading mthesaur.txt into:${reset} ${FOLDER_DD}/nvim/thesaurus/mthesaur.txt"
    curl -fLo "${FOLDER_DD}/nvim/thesaurus/mthesaur.txt" --create-dirs \
        http://www.gutenberg.org/files/3202/files/mthesaur.txt
fi

echo -e "\n"

# Ask for new virtualenv
confirm "Do you want to print available intalled pyenv versions? [y/N]" && pyenv versions
confirm "Do you want to print available pyenv versions for install? [y/N]" && pyenv install --list

# Ask for a python version and verify if is installed
read -r -p "Name of the virtualenv to use: " name
pyenv versions | grep $name > /dev/null
if [ $? -eq 0 ]; then
    echo "$name already exist. Continuing."
else
    read -r -p "Python's version to use: " ver
    pyenv versions | grep "$ver" > /dev/null
    if [ $? -ne 0 ]; then
        pyenv install "$ver"
    fi
    pyenv virtualenv "$ver" "$name"
fi


echo -e "\n${yellow}Installing requirements inside virtualenv (${name})${reset}"

python=$(PYENV_VERSION="$name" pyenv which python)
echo -e "\n${yellow}Updating pip${reset}"
PYENV_VERSION="$name" pip install -U pip
echo -e "\n${yellow}Installing python packages.${reset}"
PYENV_VERSION="$name" pip install -r "${CWD}/nvim/requirements.txt"
echo -e "\n${yellow}Installing node.js.${reset}"
PYENV_VERSION="$name" nodeenv -p
echo -e "\n${yellow}Installing node.js packages.${reset}"
cat "${CWD}/nvim/npm_requirements.txt" | PYENV_VERSION="$name" xargs npm -g install
echo -e "\n${yellow}Substituying python path in the configuration file: ${python}${reset}"
sed -i -e "s!\(^\s*let\sg:python3_host_prog\s=\s\).*!\1'${python}'!" "${FOLDER_DD}/nvim/init.vim"

echo -e "\n${yellow}Updating Nvim'- remote plugins${reset}"
nvim -c 'UpdateRemotePlugins | qa!'

echo -e "\n${yellow}Creating Symlink to NVR${reset}"
ln -sf "$(dirname $python)/nvr" "$HOME/.local/bin/nvr"

echo -e "\n${green}DONE!${reset}"
