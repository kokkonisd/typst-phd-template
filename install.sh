#!/usr/bin/bash

set -e

if [ "$TYPST_LOCAL_PACKAGES" == "" ]; then
    echo "TYPST_LOCAL_PACKAGES is not defined/empty, stopping."
    exit 1
fi

install_dir=$TYPST_LOCAL_PACKAGES/cea-template/$(cat VERSION)

# Remove installation if it exists.
rm -rf $install_dir/
# Remake installation from scratch.
mkdir -p $install_dir/
# Clone & remove git stuff.
git clone git@github.com:kokkonisd/typst-cea-template.git $install_dir/
rm -rf $install_dir/.git*
