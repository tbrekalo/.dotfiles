#!/usr/bin/env bash

set -euo pipefail

readonly ROOT="${HOME}/.dotfiles"
readonly FILES=(.bash_aliases .bashrc .profile .tmux.conf)

for file in "${FILES[@]}"; do
    source="${ROOT}/$file" 
    target="${HOME}/$file"

    [[ -L "${target}" && "$(readlink "${target}")" == "${source}" ]] && echo "already linked: ${file}" && continue
    if [[ -e "${target}" || -L "${target}" ]]; then
        mv "${target}" "${target}.old"
        echo "backup: ${target} -> ${target}.old"
    fi

    ln -s "${source}" "${target}"
    echo "linked: ${source} -> ${target}"
done
