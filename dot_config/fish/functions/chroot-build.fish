function chroot-build
    set -l usage "Usage: chroot-build normal|go|nodejs|rust|all"
    if test (count $argv) -ne 1
        echo $usage
        return 1
    end

    set -l valid_modes normal go nodejs rust all
    if not contains -- $argv[1] $valid_modes
        echo "Invalid mode: $argv[1]"
        echo $usage
        return 1
    end

    # 定义共享挂载组
    set -l base_mounts -d ~/AUR/pkgs:/mnts/pkgs

    set -l go_mounts \
        -d ~/.cache/go/mod:/mnts/go/mod \
        -d ~/.cache/go-build:/mnts/go/build

    set -l nodejs_mounts \
        -d ~/.config/npm:/mnts/npm/config \
        -d ~/.cache/npm:/mnts/npm/cache \
        -d ~/.local/share/npm:/mnts/npm/data \
        -d ~/.local/state/npm/logs:/mnts/npm/logs \
        -d ~/.cache/yarn:/mnts/yarn

    set -l rust_mounts \
        -d ~/.local/share/cargo:/mnts/cargo

    set -l ccache_mount \
        -d ~/.cache/ccache:/mnts/ccache

    # 构造挂载参数
    set -l mounts

    switch $argv[1]
        case normal
            set mounts $base_mounts
        case go
            set mounts $base_mounts $go_mounts
        case nodejs
            set mounts $base_mounts $nodejs_mounts
        case rust
            set mounts $base_mounts $rust_mounts
        case all
            set mounts $base_mounts $go_mounts $nodejs_mounts $rust_mounts $ccache_mount
    end

    makechrootpkg $mounts -cr $CHROOT -- --clean
end
