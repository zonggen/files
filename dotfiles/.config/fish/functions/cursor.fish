function cursor
    if test (count $argv) -gt 0
        set path $argv[1]
    else
        set path .
    end

    set win_path (wslpath -w $path)
    Cursor.exe $win_path >/dev/null 2>&1 &
end

