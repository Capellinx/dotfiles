function android --description "Escolhe um AVD do Android e abre no emulador"
    set -l emulator ~/Library/Android/sdk/emulator/emulator

    if not test -x $emulator
        echo "Emulator não encontrado em $emulator"
        return 1
    end

    set -l avds ($emulator -list-avds)
    if test (count $avds) -eq 0
        echo "Nenhum AVD encontrado. Crie um no Android Studio (Device Manager)."
        return 1
    end

    set -l choice
    if test (count $avds) -eq 1
        set choice $avds[1]
    else
        set choice (printf '%s\n' $avds | fzf --prompt="Emulador > " --height=40% --reverse)
    end

    test -z "$choice"; and return 0

    echo "Abrindo $choice..."
    nohup $emulator -avd $choice >/dev/null 2>&1 &
    disown
end
