function ios --description 'Escolhe um simulador iOS, dá boot e abre o Simulator'
    # Lista devices iPhone disponíveis como "Nome (Estado)\tUDID"
    set -l devices (xcrun simctl list devices available \
        | grep -E '^\s+iPhone' \
        | sed -E 's/^ +//; s/^(.*) \(([-0-9A-F]+)\) (\(.*\)) *$/\1 \3\t\2/')

    if test (count $devices) -eq 0
        echo "Nenhum simulador iPhone disponível. Rode: xcodebuild -runFirstLaunch" >&2
        return 1
    end

    # Seleciona com fzf; fallback pro primeiro se não tiver fzf
    set -l choice
    if command -qv fzf
        set choice (printf '%s\n' $devices \
            | fzf --with-nth=1 --delimiter=\t --prompt='iPhone> ' --height=40% --reverse)
    else
        set choice $devices[1]
    end

    test -z "$choice"; and return 1  # cancelou (ESC)

    set -l udid (string split \t -- $choice)[2]
    xcrun simctl boot $udid 2>/dev/null  # ignora erro se já estiver bootado
    open -a Simulator
end
