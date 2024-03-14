#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1

link_name="${HOME}/.config/nvim-nix"
target="${PWD}/nvim"

if [[ -L "$link_name" ]]; then
    if [[ "$(realpath -- "$link_name")" == "$(realpath -- "$target")" ]]; then
        echo "Already symlinked."
        exit 0
    fi
fi

if [[ -e "$link_name" ]]; then
    echo "A directory or link already exists at '$link_name' delete it first."
    exit 1
fi

ln -svf "$target" "$link_name"
