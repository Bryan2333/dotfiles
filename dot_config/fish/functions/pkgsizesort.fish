function pkgsizesort
    if test (count $argv) -eq 0 || test -z $argv
        echo "用法: pkgsizesort 关键字或正则表达式"
        return 1
    end

    set packages $(pacman -Qqs $argv)

    if test (count $packages) -eq 0
        echo "不存在符合条件的软件包"
        return 1
    end

    function __proper_size_unit
        set KiB 1024
        set MiB 1048576
        set GiB 1073741824
        set res $argv
        if test $res -gt $GiB
            set res (math $res / $GiB)
            printf "%.2fGiB" $res
        else if test $res -gt $MiB
            set res (math $res / $MiB)
            printf "%.2fMiB" $res
        else if test $res -gt $KiB
            set res (math $res / $KiB)
            printf "%.2fKiB" $res
        else
            printf "%.2fB" $res
        end
    end

    set sorted_packages (expac -S -Q '%m %n' $packages | sort -h)

    set total_size 0

    printf "软件包大小\t软件包名\n"
    for package in $sorted_packages
        set res (string split ' ' $package)
        set total_size (math $total_size + $res[1])
        set package_size (__proper_size_unit $res[1])
        set package_name $res[2]
        printf "%-10s\t%s\n" $package_size $package_name
    end
    echo "总大小: $(__proper_size_unit $total_size)"
end
