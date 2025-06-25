status is-login; or exit

## 设置XDG文件夹路径
set -gx XDG_CACHE_HOME  "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_STATE_HOME  "$HOME/.local/state"

## 设置GUI环境变量
set -gx QT_LOGGING_RULES                '*=false'
set -gx QT_SCALE_FACTOR_ROUNDING_POLICY 'Ceil'
set -gx _JAVA_AWT_WM_NONEREPARENTING    '1'
set -gx GDK_BACKEND                     'wayland,x11'
set -gx SDL_VIDEODRIVER                 'wayland,x11'
set -gx ELECTRON_OZONE_PLATFORM_HINT    'auto'

## 设置软件XDG路径
set -gx ALIYUNPAN_CONFIG_DIR    "$XDG_CONFIG_HOME/aliyunpan"
set -gx ANDROID_HOME            "$XDG_DATA_HOME/Android/Sdk"
set -gx CARGO_HOME              "$XDG_DATA_HOME/cargo"
set -gx GNUPGHOME               "$XDG_DATA_HOME/gnupg"
set -gx GOPATH                  "$XDG_DATA_HOME/go"
set -gx GOMODCACHE              "$XDG_CACHE_HOME/go/mod"
set -gx GRADLE_USER_HOME        "$XDG_DATA_HOME/gradle"
set -gx GTK2_RC_FILES           "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx HISTFILE                "$XDG_STATE_HOME/bash/history"
set -gx MAVEN_ARGS              "--settings $XDG_CONFIG_HOME/maven/settings.xml"
set -gx MYSQL_HISTFILE          "$XDG_DATA_HOME/mysql_history"
set -gx MYCLI_HISTFILE          "$XDG_DATA_HOME/mycli-history"
set -gx NODE_REPL_HISTORY       "$XDG_DATA_HOME/node_repl_history"
set -gx NPM_CONFIG_USERCONFIG   "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NUGET_PACKAGES          "$XDG_CACHE_HOME/NuGetPackages"
set -gx PNPM_HOME               "$XDG_DATA_HOME/pnpm"
set -gx PUB_CACHE               "$XDG_CACHE_HOME/pub-cache"
set -gx PYTHON_HISTORY          "$XDG_STATE_HOME/python_history"
set -gx RUSTUP_HOME             "$XDG_DATA_HOME/rustup"
set -gx TEXMFHOME               "$XDG_DATA_HOME/texmf"
set -gx TEXMFVAR                "$XDG_CACHE_HOME/texlive/texmf-var"
set -gx TEXMFCONFIG             "$XDG_CONFIG_HOME/texlive/texmf-config"
set -gx WGETRC                  "$XDG_CONFIG_HOME/wgetrc"

## 设置输入法变量
set -gx XMODIFIERS "@im=fcitx"

## 设置ssh-agent变量
set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/ssh-agent.socket"

## Vulkan解码
set -gx RADV_PERFTEST "video_decode,video_encode"

## 默认编辑器
set -gx EDITOR "vim"
set -gx VISUAL "$EDITOR"

## Chrome路径 (flutter需要)
set -gx CHROME_EXECUTABLE "/usr/bin/vivaldi"

## ADB MDNS
set -gx ADB_MDNS 0

## 拓展PATH变量
set -l user_paths \
    "$HOME/.local/bin" \
    "$XDG_DATA_HOME/npm/bin" \
    "$XDG_DATA_HOME/Android/Sdk/platform-tools" \
    "$GOPATH/bin" \
    "$PNPM_HOME" \
    "$XDG_DATA_HOME/flutter/versions/3.27.2/bin"

for i in $user_paths
    if test -d $i; and not contains $i $PATH
        set -gx -a PATH $i
    end
end
