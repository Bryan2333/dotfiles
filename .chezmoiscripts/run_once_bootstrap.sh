#!/bin/bash

all_off="$(tput sgr0)"
bold="${all_off}$(tput bold)"
blue="${bold}$(tput setaf 4)"
yellow="${bold}$(tput setaf 3)"

XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
GNUPGHOME="$XDG_DATA_HOME/gnupg"

function download_resource() {
    local dir="$1"
    local resources=("${@:2}")

    if ! [[ -d "$dir" ]]
    then
        mkdir -p "$dir"
    fi

    for resource in "${resources[@]}"
    do
        local base_name
        base_name="$(basename "$resource" | python -c "import urllib.parse, sys; print(urllib.parse.unquote(sys.stdin.read()), end='')")"

        if ! [[ -f "$dir/$base_name" ]]
        then
            wget -P "$dir" "$resource"
        fi
    done
}

function __msg_blue() {
    printf "%s==>%s %s%s\n" "${blue}" "${bold}" "$1" "${all_off}"
}

function __note() {
    printf "%s==>%s NOTE:%s %s%s\n" "${blue}" "${yellow}" "${bold}" "$1" "${all_off}"
}

function __check_command() {
    command -v "$1" >/dev/null 2>&1 
}

function change_git_url() {
    __note "Change git repo url to ssh url"
    local_repo="$XDG_DATA_HOME/chezmoi"

    cd "$local_repo" || exit 1

    [[ -d ".git" ]] && git remote set-url origin git@github.com:Bryan2333/dotfiles.git
}

function create_cache_dir() {
    if ! [[ -d "$XDG_CACHE_HOME" ]]
    then
        __note "Creating ~/.cache directory"
        mkdir -p "$XDG_CACHE_HOME"
        chattr +C "$XDG_CACHE_HOME"
    fi
}

function create_gnupghome() {
    if ! [[ -d "$GNUPGHOME" ]]
    then
        __note "Creating GNUPGHOME directory"
        install -dm700 "$GNUPGHOME"
    fi
}

function create_user_dir() {
    if ! [[ -f "$XDG_CONFIG_HOME/user-dirs.dirs" ]]
    then
        __note "Creating user directories"
        env LANG="en_US.UTF-8" xdg-user-dirs-update
        chattr +C "$HOME/Downloads"
    fi
}

function bootstrap_fish() {
    if __check_command fish
    then
        __note "Bootstrapping Fish Shell"

        if ! diff "$XDG_CONFIG_HOME/fish/__fish_plugins" "$XDG_CONFIG_HOME/fish/fish_plugins" > /dev/null 2>&1
        then
            fish -i -c "fisher install (cat $XDG_CONFIG_HOME/fish/__fish_plugins)"
        fi

        fish -i -c "yes | fish_config theme save \"Catppuccin Latte\""
        fish -i -c "set -U fish_greeting ''"
    fi
}

function bootstrap_vim() {
    if __check_command vim
    then
        __note "Bootstrapping vim"
        vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
    fi
}

function bootstrap_mpv() {
    if __check_command mpv
    then
        __note "Bootstrapping mpv player"

        download_resource "$XDG_CONFIG_HOME/mpv/scripts" "https://github.com/cyl0/ModernX/raw/main/modernx.lua" "https://github.com/po5/thumbfast/raw/master/thumbfast.lua" "https://gist.githubusercontent.com/Bryan2333/a212c9460ec8e8dd3b3296ad43da6939/raw/bbbf70690537edf0086c34e6e68a9187c694fd26/night-color.lua"

        download_resource "$XDG_CONFIG_HOME/mpv/fonts" "https://github.com/cyl0/ModernX/raw/main/Material-Design-Iconic-Font.ttf"
    fi
}

function bootstrap_catppuccin_latte() {
    __note "Bootstrapping Catppuccin Latte theme"

    download_resource "$XDG_CONFIG_HOME/bat/themes" "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme"
    bat cache --build

    download_resource "$XDG_CONFIG_HOME/lsd" "https://github.com/catppuccin/lsd/raw/refs/heads/main/themes/catppuccin-latte/colors.yaml"

    download_resource "$XDG_CONFIG_HOME/delta/themes" "https://github.com/catppuccin/delta/raw/refs/heads/main/catppuccin.gitconfig"

    download_resource "$XDG_DATA_HOME/konsole" "https://github.com/catppuccin/konsole/raw/refs/heads/main/themes/catppuccin-latte.colorscheme"

    download_resource "$XDG_CONFIG_HOME/btop/themes" "https://github.com/catppuccin/btop/raw/refs/heads/main/themes/catppuccin_latte.theme"

    fish -c "set -Ux FZF_DEFAULT_OPTS \"\
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--color=selected-bg:#bcc0cc \
--multi\""
}

change_git_url
create_cache_dir
create_gnupghome
create_user_dir
bootstrap_fish
bootstrap_vim
bootstrap_mpv
bootstrap_catppuccin_latte

__note "Boostrap finish!"
