function proxy
    set -l DEFAULT_PROXY "http://127.0.0.1:7890"
    set -l PROXY_URL_FORMAT "^(http|https|socks5|socks5h)://[a-zA-Z0-9.-]+:[0-9]+\$"

    function __set_proxy
        set -gx HTTP_PROXY $argv[1]
        set -gx http_proxy $HTTP_PROXY

        set -gx HTTPS_PROXY $HTTP_PROXY
        set -gx https_proxy $HTTP_PROXY

        set -gx ALL_PROXY $HTTP_PROXY
        set -gx all_proxy $HTTP_PROXY

        set -gx NO_PROXY "127.0.0.0/8, 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, 100.64.0.0/10, 162.14.0.0/16, localhost, *.local"
        set -gx no_proxy $NO_PROXY
    end

    switch $argv[1]
        case "on"
            __set_proxy $DEFAULT_PROXY
        case "off"
            set -e HTTP_PROXY 
            set -e http_proxy

            set -e HTTPS_PROXY
            set -e https_proxy

            set -e ALL_PROXY
            set -e all_proxy

            set -e NO_PROXY
            set -e no_proxy
        case "show"
            echo "http_proxy: $http_proxy"
            echo "HTTP_PROXY: $HTTP_PROXY"
            echo "-----------------------------------------"
            echo "https_proxy: $https_proxy"
            echo "HTTPS_PROXY: $HTTPS_PROXY"
            echo "-----------------------------------------"
            echo "all_proxy: $all_proxy"
            echo "ALL_PROXY: $ALL_PROXY"
            echo "-----------------------------------------"
            echo "no_proxy: $no_proxy"
            echo "NO_PROXY: $NO_PROXY"
        case "set"
            if test -z $argv[2]
                echo "No proxy server provided."
                return 1
            end

            if ! string match -q -r $PROXY_URL_FORMAT $argv[2]
                echo "Wrong proxy URL."
                return 1
            end

            __set_proxy $argv[2]
        case "*"
            echo "Usage: proxy [on|off|show|set protocol://host:port]"
            return 1
    end
end
