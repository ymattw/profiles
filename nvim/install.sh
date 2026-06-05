#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

readonly SELF_DIR=$(cd $(dirname $0) && pwd)

mkdir -p ~/.config/nvim
rsync -av --exclude install.sh $SELF_DIR/ ~/.config/nvim/

function has_command {
    command -v "$1" >/dev/null 2>&1
}

function check_and_install {
    local cmd_name="$1"
    shift

    if has_command "$cmd_name"; then
        echo "✔ $cmd_name is already installed."
    else
        echo "Installing $cmd_name..."
        "$@" || echo "✘ Failed to install $cmd_name"
    fi
}

function github_release_install {
    local cmd_name="$1"
    local repo="$2"

    local release_json
    release_json=$(curl -s "https://api.github.com/repos/${repo}/releases/latest")

    local version
    version=$(echo "$release_json" | grep '"tag_name":' | head -n 1 | cut -d '"' -f 4)
    if [[ -z "$version" ]]; then
        echo "✘ Failed to fetch version string from API for $repo"
        return 1
    fi

    local os_arch
    os_arch="$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m)"
    local url
    url=$(echo "$release_json" \
        | grep '"browser_download_url":' \
        | grep -i "$os_arch" \
        | head -n 1 \
        | cut -d '"' -f 4)

    if [[ -z "$url" ]]; then
        echo "✘ Failed to find download URL for $repo matching $os_arch"
        return 1
    fi

    local file=$(basename "$url")
    local tmpf="/tmp/$$-${file}"
    trap "rm -f $tmpf" RETURN

    curl -sSL -o "$tmpf" "$url"

    local install_dir="$HOME/.local/share/${cmd_name}-${version}"
    mkdir -p "$install_dir"
    mkdir -p ~/.local/bin

    if [[ "$file" == *.tar.gz ]]; then
        tar -xzf "$tmpf" -C "$install_dir"
    elif [[ "$file" == *.zip ]]; then
        unzip -o "$tmpf" -d "$install_dir"
    else
        echo "✘ Unknown archive format for $file."
        return 1
    fi

    local bin_path
    if [ -f "$install_dir/bin/$cmd_name" ]; then
        bin_path="$install_dir/bin/$cmd_name"
    elif [ -f "$install_dir/$cmd_name" ]; then
        bin_path="$install_dir/$cmd_name"
    else
        echo "✘ Could not find executable $cmd_name in extracted archive."
        return 1
    fi

    ln -sf "$bin_path" ~/.local/bin/"$cmd_name"
    echo "✔ $cmd_name installed to ~/.local/bin"
}

if [[ "$OSTYPE" == "darwin"* ]]; then
    check_and_install gopls brew install gopls
    check_and_install pylsp brew install python-lsp-server
    check_and_install stylua brew install stylua
    check_and_install pipx brew install pipx
    check_and_install pyink pipx install pyink
elif [[ -f /etc/debian_version ]]; then
    check_and_install gopls sudo apt install -y gopls
    check_and_install pylsp sudo apt install -y python3-pylsp
    check_and_install stylua github_release_install stylua JohnnyMorganz/StyLua
    check_and_install pipx sudo apt install -y pipx
    check_and_install pyink pipx install pyink
else
    echo "✘ Unsupported operating system."
    exit 1
fi

if has_command node; then
    check_and_install prettier npm install -g prettier
    check_and_install tsc npm install -g typescript
    check_and_install typescript-language-server npm install -g typescript-language-server
fi

echo "✔ Neovim installation and tool setup completed successfully!"
