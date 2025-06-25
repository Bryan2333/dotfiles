function pkgstatus
    for cmd in expac aur-check-updates
        if ! type -q $cmd
            echo "请先安装$cmd"
            return 1
        end
    end

    function __print_package_status
        echo -e "\e[1;38;2;177;225;139m==>\e[0m $argv[1]: \e[1;38;2;86;182;194m$argv[2]\e[0m"
    end

    function __print_delimiter
        echo -e "\e[1;38;2;63;212;224m========================================================\e[0m"
    end

    function __cal_total_package_size
        set total_size 0
        for size in (expac %m)
            set total_size (math $total_size + $size)
        end
        printf "%.2f GiB" (math $total_size / 2^30)
    end

    function __proper_unit
        set KiB 1024
        set MiB 1048576
        set GiB 1073741824
        set total_sum $argv
        if test $total_sum -gt $GiB
            set total_sum (math $total_sum / $GiB)
            printf "%.2f GiB" $total_sum
        else if test $total_sum -gt $MiB
            set total_sum (math $total_sum / $MiB)
            printf "%.2f MiB" $total_sum
        else if test $total_sum -gt $KiB
            set total_sum (math $total_sum / $KiB)
            printf "%.2f KiB" $total_sum
        else
            printf "%.2f B" $total_sum
        end
    end

    # 缓存路径
    set LOCALREPO_DIR $HOME/AUR/pkgs/
    set PACMAN_CACHE_DIR /var/cache/pacman/pkg

    set PACMAN_VERSION (string match -r "Pacman v\d.+ - libalpm v\d.+" (pacman -V))
    set TOTAL_PACKAGE_NUM (count (pacman -Qq))
    set TOTAL_PACKAGE_EXPLICITY (count (pacman -Qqe))
    set TOTAL_PACKAGE_AUR (count (pacman -Qqm))
    set TOTAL_PACKAGE_SIZE (__cal_total_package_size)
    set PACMAN_CACHE_SIZE (__proper_unit (string match -r "^\d+" (du -b $PACMAN_CACHE_DIR)))
    set LOCALREPO_SIZE 0
    if test -d $LOCALREPO_DIR
        set LOCALREPO_SIZE (__proper_unit (string match -r "^\d+" (du -b $LOCALREPO_DIR)))
    end
    set TOP10_PACKAGES (expac -S -H M -Q '%m %n' (pacman -Qq) | sort -rh | head -n 10)

    echo -e "\e[1;38;2;177;225;139m==>\e[0m $PACMAN_VERSION"
    __print_delimiter
    __print_package_status "已安装的软件包总数" $TOTAL_PACKAGE_NUM
    __print_package_status "已安装的外部软件包" $TOTAL_PACKAGE_AUR
    __print_package_status "单独指定安装的软件包" $TOTAL_PACKAGE_EXPLICITY
    __print_package_status "软件包占用的总大小" $TOTAL_PACKAGE_SIZE
    __print_package_status "Pacman缓存大小" $PACMAN_CACHE_SIZE
    __print_package_status "本地仓库大小" $LOCALREPO_SIZE
    __print_delimiter

    echo -e "\e[1;38;2;177;225;139m==>\e[0m 十个最大的软件包"
    for PACKAGE in $TOP10_PACKAGES
        set tmp (string split ' ' $PACKAGE)
        set PACKAGE_SIZE $tmp[1-2]
        set PACKAGE_NAME $tmp[3]
        echo -e "\e[1m$PACKAGE_NAME\e[0m: \e[1;38;2;86;182;194m$PACKAGE_SIZE\e[0m"
    end
    __print_delimiter

    echo -e "\e[1;38;2;177;225;139m==>\e[0m 可更新的AUR软件包"
    aur-check-updates --repos core,extra -n
end
