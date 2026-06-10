set fish_greeting ""
set -x EDITOR nvim
set -x SHELL /opt/homebrew/bin/fish
set -gx TERM xterm-256color

# Auto-start tmux (each terminal tab gets its own session)
if status is-interactive; and not set -q TMUX
    set -l session_name "tab-"(random)
    tmux new-session -A -s $session_name
end

# Tide theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# starship init fish | source
zoxide init fish | source
fzf --fish | source

function ls
    set -l target "."
    if test (count $argv) -gt 0
        set target $argv[-1]
    end
    set -l dir (realpath $target)
    echo ""
    printf "    Directory: %s\n" $dir
    echo ""
    printf "\033[32m%-8s  %16s  %10s  %-s\033[0m\n" "Mode" "LastWriteTime" "Length" "Name"
    printf "%-8s  %16s  %10s  %-s\n" "----" "-------------" "------" "----"
    command ls -lAT $target | tail -n +2 | while read -l line
        set -l perms (string sub -l 10 -- $line)
        set -l rest (string replace -r '^[^ ]+\s+\d+\s+\S+\s+\S+\s+' '' -- $line)
        set -l size (string match -r '^\d+' -- $rest)
        set rest (string replace -r '^\d+\s+' '' -- $rest)
        # -T gives: Mon DD HH:MM:SS YYYY Name
        set -l mon (string match -r '^\S+' -- $rest)
        set rest (string replace -r '^\S+\s+' '' -- $rest)
        set -l day (string match -r '^\d+' -- $rest)
        set rest (string replace -r '^\d+\s+' '' -- $rest)
        set -l time_full (string match -r '^\S+' -- $rest)
        set rest (string replace -r '^\S+\s+' '' -- $rest)
        set -l year (string match -r '^\d{4}' -- $rest)
        set -l name (string replace -r '^\d{4}\s+' '' -- $rest)
        set -l time_short (string replace -r '(\d+:\d+):\d+' '$1' -- $time_full)
        set -l date_str "$day.$mon.$year  $time_short"
        set -l mode "-a---"
        if string match -q 'd*' -- $perms
            set mode "d----"
            set size ""
        end
        printf "%-8s  %16s  %10s  %s\n" $mode $date_str $size $name
    end
    echo ""
end
alias ll='ls'
alias la='ls -a'
alias lla='ls -a'
alias lt='eza -T --git --icons'
alias g='git'
alias c='claude'
command -qv nvim && alias vim nvim
alias spotify="ncspot"
alias reset='source ~/.config/fish/config.fish'
alias ios='xcrun simctl boot "iPhone 16" && open -a Simulator'
alias android='emulator -avd Pixel_4'
alias doapps='doctl apps list --format ID,Spec.Name,ActiveDeployment.ID,InProgressDeployment.ID,Updated'
alias dodeploys='doctl apps list-deployments'
alias dologs='doctl apps logs'
alias dologsf='doctl apps logs --follow'
alias dodb='doctl databases list'
alias webstorm='/Applications/WebStorm.app/Contents/MacOS/webstorm'

set -x PATH $PATH ~/.local/bin

set -x GOPATH ~/go
set -x PATH $PATH $GOPATH/bin

set -x ANDROID_HOME ~/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/emulator
set -x PATH $PATH $ANDROID_HOME/tools
set -x PATH $PATH $ANDROID_HOME/tools/bin
set -x PATH $PATH $ANDROID_HOME/platform-tools

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/opt/homebrew/share/google-cloud-sdk/path.fish.inc' ]
    . '/opt/homebrew/share/google-cloud-sdk/path.fish.inc'
end

# Yazi - ao sair, muda pro diretório que você navegou
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
    # Restore tab title to current directory after exiting Yazi
    set -l dir_name (basename (pwd))
    if test (pwd) = $HOME
        set dir_name "~"
    end
    bash ~/.config/kitty/scripts/set-tab-title.sh "$dir_name"
end

# Auto-start Yazi (dentro do tmux)
if status is-interactive; and set -q TMUX; and not set -q YAZI_LEVEL
    y
end

