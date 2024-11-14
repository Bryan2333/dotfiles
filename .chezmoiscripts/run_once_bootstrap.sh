#!/bin/bash

all_off="$(tput sgr0)"
bold="${all_off}$(tput bold)"
blue="${bold}$(tput setaf 4)"
yellow="${bold}$(tput setaf 3)"

XDG_CACHE_HOME="$HOME/.cache"
XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
GNUPGHOME="$XDG_DATA_HOME/gnupg"

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
    local_repo="$(chezmoi source-path)"

    cd "$local_repo" || exit 1

    git remote set-url origin git@github.com:Bryan2333/dotfiles.git
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
        __note "Bootstraping Fish Shell"
        fish -i -c "set -U fish_greeting ''"

        if ! diff "$XDG_CONFIG_HOME/fish/__fish_plugins" "$XDG_CONFIG_HOME/fish/fish_plugins" > /dev/null 2>&1
        then
            fish -i -c "fisher install (cat $XDG_CONFIG_HOME/fish/__fish_plugins)"
        fi
    fi
}

function bootstrap_vim() {
    if __check_command vim
    then
        __note "Bootstraping vim"
        vim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
    fi
}

function bootstrap_mpv() {
    if __check_command mpv
    then
        __note "Bootstraping mpv player"

        if ! [[ -d "$XDG_CONFIG_HOME/mpv/scripts" ]]
        then
            wget -P "$XDG_CONFIG_HOME/mpv/scripts" https://github.com/cyl0/ModernX/raw/main/modernx.lua
            wget -P "$XDG_CONFIG_HOME/mpv/scripts" https://github.com/po5/thumbfast/raw/master/thumbfast.lua
            wget -P "$XDG_CONFIG_HOME/mpv/scripts" https://gist.githubusercontent.com/Bryan2333/a212c9460ec8e8dd3b3296ad43da6939/raw/bbbf70690537edf0086c34e6e68a9187c694fd26/night-color.lua
        fi

        if ! [[ -d "$XDG_CONFIG_HOME/mpv/fonts" ]]
        then
            wget -P "$XDG_CONFIG_HOME/mpv/fonts" https://github.com/cyl0/ModernX/raw/main/Material-Design-Iconic-Font.ttf
        fi
    fi
}

change_git_url
create_cache_dir
create_gnupghome
create_user_dir
bootstrap_fish
bootstrap_vim
bootstrap_mpv

__note "Boostrap finish!"
