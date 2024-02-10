#!/usr/bin/bash

set -e

offline_mode=0
remote=$(git remote get-url origin)

function print_info {
    echo -e "\e[1m\e[38;5;70m> $1\e[0m"
}

function print_error {
    echo -e "\e[1m\e[38;5;160m> ERROR: $1\e[0m"
}

function fail {
    print_error $1
    exit 1
}

if [ "$1" == "-o" ] || [ "$1" == "--offline" ]; then
    offline_mode=1
elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Usage: ./install.sh [-o/--offline]"
    exit 0
fi


if [ "$TYPST_LOCAL_PACKAGES" == "" ]; then
    fail "TYPST_LOCAL_PACKAGES is not defined/empty, stopping."
fi

install_dir=$TYPST_LOCAL_PACKAGES/phd-template/$(cat VERSION)
print_info "Installing local Typst package at '$install_dir'..."

if [ -d $install_dir ]; then
    print_info "Directory '$install_dir' already exists. "
    read -p "Overwrite? [yY/nN]: " overwrite

    if [ "$overwrite" == "y" ] || [ "$overwrite" == "Y" ]; then
        rm -rf $install_dir/
    else
        print_info "Not overwriting existing directory."
        exit 0
    fi
fi

mkdir -p $install_dir/

if [ "$offline_mode" == "1" ]; then
    print_info "Installing in offline mode (copying local files)..."
    # Just copy local dir to destination.
    cp -r . $install_dir
else
    print_info "Cloning from '$remote'..."
    # Clone & remove git stuff.
    git clone $remote $install_dir/
    rm -rf $install_dir/.git*
fi

# Remove the installer too.
rm -rf $install_dir/install.sh

print_info "Done! Package is now in '$install_dir'."
