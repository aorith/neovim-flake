#!/usr/bin/env bash
cd "$(dirname -- "$0")" || exit 1

target="${PWD}/nvim"

for link_name in "${HOME}/.config/nvim" "${HOME}/.config/nvim-nix"; do
    echo "Creating link: '$link_name' -> '$target' ..."

    if [[ -L "$link_name" ]]; then
        if [[ "$(realpath -- "$link_name")" == "$(realpath -- "$target")" ]]; then
            echo "Already symlinked."
            continue
        fi
    fi

    if [[ -e "$link_name" ]]; then
        echo "A directory or link already exists at '$link_name' delete it first."
        continue
    fi

    ln -svf "$target" "$link_name"
done
