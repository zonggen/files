# NOTE: only tested on linux
function gport --description "Grep process running on port"
    if test (count $argv) -ne 1
        echo "Usage: gport <port>"
        return 1
    end
    # ipv4 only
    set --local ans (sudo netstat -tulpn | grep -E "\w+\.\w+\.\w+\.\w+\:$argv[1]" | awk -F/ '{print $1}' | awk '{split($NF, array, "/"); print array[1]}')
    if test -z $ans
        return 1
    end
    echo $ans && return 0
end
