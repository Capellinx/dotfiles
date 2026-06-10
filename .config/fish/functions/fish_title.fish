function fish_title
    set -l dir (basename (pwd))
    if test (pwd) = $HOME
        echo "~"
    else
        echo $dir
    end
end
