status is-interactive; or exit

# env {{{

## FZF默认命令
set -gx FZF_DEFAULT_COMMAND "find -xdev \! \( -path '*/.git' -prune \) -printf '%P\n'"

## rustup镜像
set -gx RUSTUP_DIST_SERVER https://mirrors.ustc.edu.cn/rust-static
set -gx RUSTUP_UPDATE_ROOT https://mirrors.ustc.edu.cn/rust-static/rustup

## dart-pub镜像
set -gx PUB_HOSTED_URL https://mirrors.tuna.tsinghua.edu.cn/dart-pub

## less命令显示PUA
set -gx LESSUTFCHARDEF E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p

## kerl路径
set -gx KERL_BASE_DIR $HOME/.cache/kerl

## fvm路径
set -gx FVM_CACHE_PATH $HOME/.local/share/flutter
# }}}

# abbr {{{

## su
abbr -a mysu 'sudo su - root'

## nvim
abbr -a svim 'sudo vim'

## 操作文件的安全措施
abbr -a --position anywhere rm 'rm -I'
abbr -a --position anywhere mv 'mv -i'
abbr -a --position anywhere cp 'cp -i'

## 网络工具
abbr -a ping 'ping -c 4'
abbr -a tcping 'tcping -c 4'

## wl-clipboard
abbr -a wlc 'wl-copy'
abbr -a wlp 'wl-paste'

## systemctl
abbr -a --position anywhere sc 'systemctl'
abbr -a scu 'systemctl --user'

## Btrfs
abbr -a bdf 'btrfs filesystem df -h /'

## zip
abbr -a showzip 'bsdtar -tf'
abbr -a zip 'bsdtar -caf'

## Rust系列命令工具
abbr -a --position anywhere tree 'lsd -A --tree'
abbr -a ls 'lsd'
abbr -a ll 'lsd -lh'
abbr -a la 'lsd -Alh'
abbr -a --position anywhere cat 'bat'

## history显示格式
abbr -a history 'history --show-time="%Y-%m-%d %H:%M:%S "'

## Git命令
abbr -a git-log 'git log --oneline --graph --decorate --all'

## misc
abbr -a reload 'exec fish --interactive'
abbr -a replasma 'systemctl --user restart plasma-plasmashell.service'
abbr -a xlsclients 'qdbus6 org.kde.KWin /KWin org.kde.KWin.showDebugConsole'
abbr -a aria2c 'aria2c -s16 -x16 -k1M'

## makechrootpkg
abbr -a chroot-update 'arch-nspawn ~/AUR/build-chroot/root pacman -Syu'

## pacman
abbr -a pasy 'sudo bash -c "pacman -Sy && pacman -Fy && pkgfile -u --compress=lz4"'
abbr -a pasu 'sudo pacman -Su'
abbr -a paqu 'pacman -Qu'
# }}}

# key bindings {{{

## ctrl+right arrow防止abbr展开
bind -M insert \e\[1\;3C "commandline -i ' '"
# }}}
