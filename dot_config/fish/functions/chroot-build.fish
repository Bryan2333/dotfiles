function chroot-build
    set -l usage "
Usage:
  chroot-build [makechrootpkg options...] -- [makepkg options...]

Examples:
  chroot-build -- --clean
  chroot-build -I mypkg.pkg.tar.zst -- --nocheck
"

    if test "$argv[1]" = "-h"
        echo $usage
        return 0
    end

    if not test -f (pwd)/PKGBUILD
        echo "No PKGBUILD found in current directory"
        return 1
    end

    set -l CHROOT ~/AUR/build-chroot

    set -l extra_args $argv[1..-1]

    # 定义挂载
    set -l mounts \
        -d ~/AUR/pkgs:/mnts/pkgs \
        -d ~/.cache/go/mod:/mnts/go/mod \
        -d ~/.cache/go-build:/mnts/go/build \
        -d ~/.config/npm:/mnts/npm/config \
        -d ~/.cache/npm:/mnts/npm/cache \
        -d ~/.local/share/npm:/mnts/npm/data \
        -d ~/.local/state/npm/logs:/mnts/npm/logs \
        -d ~/.cache/yarn:/mnts/yarn \
        -d ~/.local/share/cargo:/mnts/cargo

    # 检查挂载目录是否存在
    for i in $mounts
        test "$i" = "-d"; and continue

        set -l pair (string split ':' $i)
        set -l src_dir $pair[1]
        set -l dst_dir "$CHROOT$pair[2]"

        not test -d $src_dir; and mkdir -p $src_dir
        not test -d $dst_dir; and mkdir -p $dst_dir
    end

    makechrootpkg $mounts -c -r $CHROOT $extra_args
end

