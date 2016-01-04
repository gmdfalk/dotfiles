#!/usr/bin/env zsh
#   _________  _   _ ____   ____
#  |__  / ___|| | | |  _ \ / ___|
#    / /\___ \| |_| | |_) | |
# _ / /_ ___) |  _  |  _ <| |___
#(_)____|____/|_| |_|_| \_\\____|
#

#{{{ CHECKS
[[ -z "$PS1" ]] && return

# determine shell
#~ _shell() {
    #~ shell="sh"
    #~ if test -f /proc/mounts; then
        #~ case $(/bin/ls -l /proc/$$/exe) in
            #~ *bash) shell=bash ;;
            #~ *dash) shell=dash ;;
            #~ *ash)  shell=ash ;;
            #~ *ksh)  shell=ksh ;;
            #~ *zsh)  shell=zsh ;;
        #~ esac
    #~ fi
#~ }
#~ _shell
[[ -n $ZSH_VERSION ]] && shell="zsh"

# sourced for autojump
[[ $shell = zsh ]] && . /etc/profile

_have() { command -v "$@" &>/dev/null; }

_islinux=false
[[ "$(uname -s)" =~ "Linux|GNU|GNU/*" ]] && _islinux=true

_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true

_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true

# if [[ -n "$_isxrunning" && -n "$_isroot" ]];then
#     export DISPLAY=:0
#     #[[ $HOST == htpc ]] && export XAUTHORITY=/home/slave/.Xauthority || export XAUTHORITY=/home/demian/.Xauthority
# fi

[[ -z $HOST ]] && HOST=$HOSTNAME
#}}}
#{{{ ENVIRONMENT
# set path and remove duplicates
export PATH=~/.bin:$PATH
#typeset -U PATH

export  CC=/usr/bin/gcc             \
        BROWSER=firefox             \
        TTYBROWSER=firefox          \
        EDITOR="vim -p"             \
        SYSTEMD_EDITOR="vim -p"	    \
        VISUAL="vim -p"             \
       # GREP_OPTIONS="--color=auto" \
       # GREP_COLOR="1;36"           \
        LANG=en_US.UTF-8            \
        LC_ALL=en_US.UTF-8          \
        LESS="-MWi -x4 --shift 5"   \
        LS_COLORS="no=00:fi=00:rs=0:di=04:ow=04:ex=00:"

alias p="pacman"
alias sp="sudo pacman"

if _have less; then
    alias more=less
    export  PAGER=less \
            LESSHISTFILE=- \
            LESSCHARSET="utf-8"

    if $_islinux && [[ "$TERM" != 'linux' ]]; then
        export LESS_TERMCAP_mb=$'\E[01;31m'    # begin blinking
        export LESS_TERMCAP_md=$'\E[01;36m'    # begin bold
        export LESS_TERMCAP_me=$'\E[0m'    # end mode
        export LESS_TERMCAP_se=$'\E[0m'    # end standout-mode
        export LESS_TERMCAP_so=$'\E[01;46;37m' # begin standout-mode - info box
        export LESS_TERMCAP_ue=$'\E[0m'    # end underline
        export LESS_TERMCAP_us=$'\E[01;32m'    # begin underline
    fi
fi
#}}}
#{{{ ROOT ALIASES AND RETURN
### CD
up() { # go up n directories
    [[ "${1/[^0-9]/}" == "$1" ]] && {
    local ups=""
    for i in $(seq 1 $1); do
        ups=$ups"../"
    done
    cd $ups
    } || echo "usage: up INTEGER"
}

xd() { echo $PWD | xclip -i ; xclip -o; }
xcd() { cd $(xclip -o); }

### ALIASES
## ls
[[ $_islinux = true ]] && alias ls="ls --color=auto --group-directories-first -h" || alias ls="ls -h"
alias l2="ls++"
alias ll="l -l"                            # list detailed with human-readable sizes
alias lw="l -1"                            # windows-style list
alias la="ll -A"                           # list all but not . and ..
alias lA="ll -a"
alias lat="llt -A"                         # lt with -A
alias lax="llx -A"                         # lx with -A
alias lay="lly -A"                         # ly with -A
alias llt="ll -rt"                         # sort by modification time
alias llx="ll -BX"                         # sort by extension
alias lly="ll -rS"                         # sort by size
alias lr="l -R"
alias llr="ll -R"
alias lbig="/bin/ls --color=auto -lrSh"    # list biggest
[[ $shell = zsh ]] && alias lbigr="lbig * *{f}"
alias lnew="/bin/ls --color=auto -lhrt"    # list newest
alias lold="/bin/ls --color=auto -lht"     # list oldest
[[ $shell = zsh ]] && alias lsmall="ls -fld *(OL)" || alias lsmall="/bin/ls --color=auto -lSh"   # list smallest
alias labig="/bin/ls --color=auto -lArSh"  # list biggest including hidden files
alias lanew="/bin/ls --color=auto -lAhrt"  # list newest including hidden files
alias laold="/bin/ls --color=auto -lAht"   # list oldest including hidden files
alias lasmall="/bin/ls --color=auto -lASh" # list smallest including hidden files
alias lsb="la $HOME/.backup"
alias lscr="ll $HOME/.local/screenshots"
alias lsdev="ls /dev | grep sd"
alias lsuid="ls -l /dev/disk/by-uuid"
alias lst="ll /tmp"

## various
alias rm="rm -Iv"                          # secure remove but less annoying than -i
alias rmr="rm -r"                          # including folders
alias mnt="mount"                          # mount
alias umnt="umount"                        # umount
[[ $shell = zsh ]] && alias clc="noglob calc --" || alias clc="calc --"

alias sctl="systemctl"
alias jctl="journalctl"
alias sstop="sctl stop $@"
alias sstart="sctl start $@"
alias srestart="sctl restart $@"
lsu() { [[ $# = 0 ]] && systemctl list-units --all || systemctl list-units --all | grep "$@"; }
lsua() { [[ $# = 0 ]] && systemctl list-unit-files --all || systemctl list-unit-files | grep "$@"; }
lsud() { [[ $# = 0 ]] && systemctl list-units | grep service || systemctl list-units | grep service | grep "$@"; }

alias pcm="pcmanfm"
#alias startx="startx &>> ~/.logs/xsession"

### ISROOT?
## if user is root he should stop parsing this file after this section.
if [[ $_isroot = true ]]; then
    # close root shell after n seconds for security reasons
    export TMOUT=180
    # root aliases
    alias chi="chattr +i"                      # immunize file
    alias chu="chattr -i"                      # unimmunize file
    alias clams="clam -r -l $HOME/.clamlog /"  # scan whole ystem
    alias freshc="sstart clamav ; freshclam ; sstop clamav" # update clamav database
    alias gettime="ntpdate stratum2-4.NTP.TechFak.Uni-Bielefeld.DE"
    ktheft() { kill $(pgrep theft); }
    alias make="time make"
    alias makepkg="time makepkg"

    alias rmdbus="rm /var/run/dbus.pid"
    alias updfonts="fc-cache -vf"              # update font cache
    alias showlog="tail -f /var/log/everything.log"
    if [[ $_isarch = true ]];then
        alias {pS,pin}="p -S"   # install
        alias {pR,pout}="p -R"  # remove
        alias prd="pR -d"       # remove omit dependencies
        alias prk="pR -k"
        alias prs="pR -s"       # remove plus unused dependencies
        alias psc="pS -c"       # clean those packages from cage that are no longer installed
        alias pscc="psc -c"     # clean the whole cache directory
        alias psf="p -Sf"       # force (re-)installation
        alias psw="p -Sw"       # download but don't install
        alias psu="p -Su"       # sys update without refresh
        alias psy="p -Sy"       # sync refresh
        alias psyu="p -Syu"     # sync refresh and update
        alias psyy="p -Syy"     # force all db to be refreshed
        alias psyyu="p -Syyu"   # force refresh and update
        alias pG="p -G"         # get pkgbuild
        alias pu="p -U"         # install local pkg
        alias mirrorupdate="reflector --verbose -l 150 -p http --sort rate --save /etc/pacman.d/mirrorlist"
        alias mirrorupdateDE="reflector --verbose -c 'Germany' -l 40 -p http --sort rate --save /etc/pacman.d/mirrorlist"
        alias popt="pacman-optimize"         # defrag pacman database
        porph(){ p -Rsc $(pacman -Qtdq); }
        sublimation(){ pacman -Rdd $(pacman -Qq | grep -v "$(pacman -Qqg base)"); }

        setup() { # run as root on a fresh system to install base and gui packages and create user
            echo -n "Download and install packages now? "
            if read -q; then
                pacman -S   alsa-utils nfs-utils rsync dosfstools ntfsprogs abs cups samba openssh ntfs-3g      \
                            autojump ethtool lm_sensors stress ncdu ntp atool xclip xsel smartmontools zsh      \
                            grc vim htop screen tmux lynx wgetpaste scrot curl clamav powertop imagemagick      \
                            laptop-mode-tools slock mpc wol mlocate ncmpcpp xorg-server xf86-video-intel vim    \
                            gamin transset-df gxmessage xdg-user-dirs zenity ttf-dejavu ttf-bitstream-vera      \
                            gtk-engines xchat reflector rxvt-unicode feh gmrun geany file-roller evince conky   \
                            conky gmpc firefox thunderbird flashplugin vlc rfkill wmctrl xdotool gimp gnuplot   \
                            gvfs tumbler lxappearance xterm dnsutils artwiz-fonts

                # yaourt, acpid
                echo -n "Install from AUR? "
                if read -q; then
                    yaourt -S phc-intel brother-lpr-drivers-laser aurvote dropbox-cli dropbox ttf-ms-fonts
                fi
            fi

            echo -n "User specific stuff too? "
            if read -q; then
                if [[ "$HOST" == htpc ]];then
                    pacman -Sy lighttpd fcgi php php-cgi mpd x11vnc
                    yaourt -S rutorrent rtorrent-extended rutorrent-plugins libtorrent-extended
                else
                    yaourt -S tp_smapi
                fi
            fi
        }
    fi

    lamb() { # beep the children's song
        beep -f 10
        echo "Marry Had A Little Lamb"
        beep -f 466.2 -l 250 -D 20 -n -f 415.3 -l 250 -D 20 -n -f 370.0 -l 250 -D 20 -n -f 415.3 -l 250 -D 20 -n -f 466.2 -l 250 -r 2 -d 0 -D 20 -n -f 466.2 -l 500 -n -f 10 -l 20
        echo "Little Lamb, Little Lamb"
        beep -f 415.3 -l 250 -r 2 -d 0 -D 20 -n -f 415.3 -l 500 -D 20 -n -f 466.2 -l 250 -D 20 -n -f 568.8 -l 250 -D 20 -n -f 568.8 -l 500 -n -f 10 -l 20
        echo "Marry Had A Little Lamb"
        beep -f 466.2 -l 250 -D 20 -n -f 415.3 -l 250 -D 20 -n -f 370.0 -l 250 -D 20 -n -f 415.3 -l 250 -D 20 -n -f 466.2 -l 250 -r 2 -d 0 -D 20 -n -f 466.2 -l 250 -n -f 10 -l 20
        echo "Whose Fleece Was White As Snow"
        beep -f 415.3 -l 250 -r 3 -D 20 -n -f 466.2 -l 250 -D 20 -n -f 415.3 -l 250 -D 20 -n -f 370.0 -l 500
    }
    # root should stop parsing this file here
    #return 0
else
    ## greeting
    if _have fortune; then
        alias ft="fortune | cowsay -W 60"
        #~ if _have cowsay;then
            #~ if (( RANDOM % 2 == 0 )); then
                #~ dir="/usr/share/cows"
                #~ file=$(/bin/ls -1 "$dir" | sort --random-sort | head -1)
                #~ cow="$(echo "$file" | sed -e "s/\.cow//")"
                #~ fortune -a | cowsay -W 60 -f $cow
                #~ fortune | cowsay -W 60
            #~ fi
        #~ fi
    fi
    export  XDG_CACHE_HOME=$HOME/.cache          \
            XDG_CONFIG_HOME=$HOME/.config        \
            XDG_CONFIG_DIRS="$HOME/.config:/etc:/etc/xdg" \
            XDG_DATA_HOME=$HOME/.config/share        \
            XDG_DESKTOP_DIR=             \
            XDG_DOWNLOAD_DIR=$HOME/down          \
            XDG_MUSIC_DIR=$HOME/var/music        \
            XDG_PICTURES_DIR=$HOME/var/pics      \
            XDG_PUBLICSHARE_DIR=$HOME/var/public     \
            XDG_TEMPLATES_DIR=$HOME/var/templates    \
            XDG_VIDEOS_DIR=$HOME/down

    # sudo
    alias hell="sudo hell"
    alias chi="sudo chattr +i"                       # immunize file
    alias chu="sudo chattr -i"                       # unimmunize file
    alias clams="sudo clam -r -l $HOME/.clamlog /"   # scan whole system
    alias ethtool="sudo ethtool"
    alias freshc="sstart clamav ; freshclam ; sstop clamav" # update clamav database
    alias freshclam="sudo freshclam"         # freshclam
    alias gettime="sudo ntpdate stratum2-4.NTP.TechFak.Uni-Bielefeld.DE"
    alias mntcache="sudo sshfs -o nonempty slave@htpc:/var/cache/pacman/pkg /var/cache/pacman/pkg"
    alias umntcache="umount /var/cache/pacman/pkg"
    alias hdparm="sudo hdparm"                       # hdparm
    alias ip="sudo ip"                               # ifconfig
    alias ifconfig="sudo ifconfig"                   # ifconfig
    alias ktheft="sudo kill $(pgrep theft)"
    alias mkinitcpio="sudo mkinitcpio"               # mkinitcpio
    alias modprobe="sudo modprobe"                   # modprobe
    alias mount="sudo mount"                         # mount
    alias nsw="sudo watch -n 3 -d -t netstat -vantp" # watch incoming connections
    alias powertop="sudo powertop"                   # powertop

    #systemctl
    _have systemctl && alias systemctl="sudo systemctl" || alias shutdown="sudo shutdown"

    alias rmmod="sudo rmmod"                         # rmmod
    alias rmdbus="sudo rm /var/run/dbus.pid"
    alias sc="s c"
    alias s-cp="s cp"
    alias scpr="s cpr"
    alias sk="s k"
    alias smv="s mv"
    alias spk="s pk"
    alias srm="s rm"
    alias srmr="s rmr"
    alias sv="sudo v"                                # $VISUAL
    alias showlog="sudo tail -f /var/log/everything.log"
    alias smartctl="sudo smartctl"
    alias su="su - "                                  # change to root directory
    alias suh="/bin/su"                              # su to root but stay in current directory
    alias umount="sudo umount"               # umount
    alias updfonts="sudo fc-cache -vf"               # update font cache
    # pacman operations requiring root privileges
    if [[ $_isarch = true ]];then
        alias {pS,pin}="sp -S"  # install
        alias {pR,pout}="sp -R" # remove
        alias prd="sp -Rd"      # remove omit dependencies
        alias prdd="sp -Rdd"      # remove omit dependencies
        alias prs="sp -Rs"      # remove plus unused dependencies
        alias psc="sp -Sc"      # clean those packages from cage that are no longer installed
        alias pscc="sp -Scc"    # clean the whole cache directory
        alias psf="sp -Sf"      # force (re-)installation
        alias psw="sp -Sw"      # download but don't install
        alias psu="sp -Su"      # sys update without refresh
        alias psy="sp -Sy"      # sync refresh
        alias psyu="sp -Syu"    # sync refresh and update
        alias psyy="sp -Syy"    # force all db to be refreshed
        alias psyyu="sp -Syyu"  # force refresh and update
        alias pu="sp -U"        # install local pkg
        alias pclean="s pclean" # .bin/pclean with sudo privileges
        alias mirrorupdate="sudo reflector --verbose -l 150 -p http --sort rate --save /etc/pacman.d/mirrorlist"
        alias mirrorupdateDE="sudo reflector --verbose -c 'Germany' -l 40 -p http --sort rate --save /etc/pacman.d/mirrorlist"
        alias popt="s pacman-optimize"        # defrag pacman database
        porph(){ sp -Rsc $(pacman -Qtdq); }
    fi
    svs() { sudo cp -iv "$1" ${1}.backup && sudo $VISUAL "$1"; }
fi

# reboot & halt
if _have systemctl;then
    alias suspend="systemctl suspend"
    rbt(){ umnta; countdown 5 && systemctl reboot; }
    rbtn(){ umnta; systemctl reboot; }
    rbtin(){ echo "rebooting in $1" && sleep $1 && rbt; }
    hlt() { umnta; countdown 5 && systemctl poweroff; }
    hltin(){ echo "shutting down in $1" && countdown $1 && hlt; }
    slpin(){ echo "suspending in $1" && countdown $1 && systemctl suspend; } #FIXME
else
    alias rbt="umnta; shutdown -r now"
    alias rbtin="umnta; shutdown -r"
    alias hlt="umnta; shutdown -h now"
    alias hltin="umnta; shutdown -h"
    alias suspend="pm-suspend"
fi
#}}}

#{{{ BASIC USER ALIASES AND FUNCTIONS
## colorize
if _have grc; then
    alias .cl="grc -es --colour=auto"
    alias configure=".cl ./configure"
    alias diff=".cl diff"
    alias make=".cl make"
    alias gcc=".cl gcc"
    alias g++=".cl g++"
    #alias as=".cl as"
    #alias gas=".cl gas"
    #alias ld=".cl ld"
    alias netstat=".cl netstat"
    alias ping=".cl ping"
    alias traceroute=".cl traceroute"
fi

## short commands
# b: popd
alias c=cat
alias d=pwd
#f: find in current directory
alias g=git
alias h=history
#j: autojump
alias k=kill
alias l=ls
#m: gvim / hash for /media
[[ $shell = zsh ]] && alias n="noglob note" || alias n="note"
alias nn=notemed
#p: pacman wrapper
#q: run quietly and disowned
#r: redo or substitute (zsh builtin)
#s: sudo / hash for /media/series
#t: hash for /tmp
alias v="$VISUAL"
#w: /usr/bin/w
alias x=exit
#y: aur wrapper

## mpd
export MPD_HOST=192.168.0.2
export MPD_PORT=6600
if _have ncmpcpp;then
    alias cmpc="ncmpcpp"
elif _have ncmpc;then
    alias cmpc="ncmpc -h 192.168.0.2"
fi
if _have mpc; then
    alias pla="mpc --no-status play"
    alias tog="mpc --no-status toggle"
    alias nxt="mpc --no-status next"
    alias pause="mpc --no-status pause"
    alias prev="mpc --no-status prev"
    alias rnd="mpc random G random"
    alias rpt="mpc repeat G repeat"
    alias rptc="mpc single G single"
    alias shfl="mpc --no-status shuffle"
    alias pl="mpc --no-status playlist"
    alias lock="pause && slock && play"
    #alias lsm="mpc listall"
    alias lspl="mpc lsplaylists"
    alias add="mpc add"
    alias np='mpc --format "  %artist% - %title% #[%album%#]" | head -n1'
    alias vol="mpc --no-status volume $1"
    alias clm="mpc clear"
    load() {
        (mpc clear
        sleep .1
        mpc load $@
        sleep .1
        mpc play) &>/dev/null
        mpc --format "  %title% by %artist% #[%album%#]" | head -n1
    }
    mcd() { [[ $HOST = laptop ]] && cd /mnt/smb/music || cd /media/games/var/"$(dirname "$(mpc --format '%file%'|head -n1)")"; }
    addartist() { mpc search artist "$*" | mpc add &>/dev/null && mpc play; }
fi
if _have mocp;then
    mcheck() {
        _mrunning=$(pgrep mocp)
        [[ -z $_mrunning ]] && mocp -S
    }
    mgo() { mcheck ; mocp -c && mocp -a "$@" && mocp -p; }
    mpt() { mcheck ; mocp -l "$@"; }
    alias mplay="mocp -p"
    alias mtog="mocp -G"
    alias mnext="mocp -f"
    alias mpause="mocp -P"
    alias mprev="mocp -r"
    alias mkill="killall mocp"
    alias madd="mocp -a"
    alias minfo="mocp -i"
    alias mcl="mocp -c"
    alias msync="mocp -y"
    alias mvol="mocp -v $1"
fi
if _have goodsong;then
    alias gs="goodsong"
    alias gsu="goodsongupdate"
fi
alias master="amixer get Master"
alias mt="amixer -q set Master toggle"
svol() { # control system volume
    if [[ $# = 0 ]];then
        amixer get Master | grep -o -e '[0-9]*%' -e '\[on\]' -e '\[off\]' | head -n 2
    else
        amixer -q set Master $1%
    fi
}

## system
reprobe() {
    if [[ $1 = "-f" ]];then
        modprobe -rf $@
        modprobe $@
    else
        modprobe -r $@
        modprobe $@
    fi
  }
alias path='echo -e "${PATH//:/\n}"'
alias cl="clear"                                 # clear screen
if _have clamscan;then
    alias clam="clamscan --bell -i"                # scan a file
    alias clami="clam -r ~i"   # scan incoming files
    alias clamt="clam -r /tmp"             # scan /tmp
fi
alias cpr="cp -r"                    # copy recursively
alias cpv="rsync -Ph"                            # use rsync as cp alternative due to more information
alias mvv="rsync -Ph --remove-source-files"      # use rsync as mv alternative
alias da="date '+%A, %d.%m.%Y, %T'"              # Wednesday, 21.04.2010, 14:22:25
alias dat="date '+%A, %B %d, %Y [%T]'"           # Thursday, April 15, 2010 [16:27:42]
alias df="df -khT"                               # file system disk space usage in human-readable sizes
alias du="du -khc"                               # disk space usage in human-readable sizes
alias du1="du --max-depth=1"                     # look no deeper than one directory level
alias dus="du -s"                                # disk space usage in human-readable sizes
alias duchs="du -chs * 2>/dev/null |sort -rn |head -11" # disk hog
alias eg="egrep --color=auto"                    # colourized egrep
alias egrep="egrep --color=auto"                 # colourized egrep
alias free="free -m"                             # show sizes in MB
alias gi="grep -i"
alias hist="history | grep"                      # search cmd history
alias ka="killall"                               # killall
alias less="less -iF"                            # less with ignore-case and quit-if-one-screen enabled
alias nano="vim"
if _have netstat;then
    alias ns="netstat -alnp --protocol=inet | grep -v CLOSE_WAIT | cut -c-6,21-94 | tail"
    alias nsp="netstat --all --numeric --programs --inet"
fi
alias parts="cat /proc/partitions"
alias ping1="ping 192.168.0.1"
alias ping2="ping 192.168.0.2"
alias pingg="ping www.google.de"
alias md="mkdir -pv"                             # create parents and verbose output

alias rd="rmdir"                                 # remove directory
_have rsync && alias rsynn="rsync -r -n -t -p -o -g -v --progress --delete -l"
_have sensors && alias sensors="sensors 2>/dev/null | grep -v '+0.0°C'"
pw() { echo $(< /dev/urandom tr -cd "[:graph:]" | head -c $1); }

## apps
alias lbo="libreoffice"
alias lbw="lowriter"

## pacman
if [[ $_isarch = true ]];then
    alias pq="p -Q"         # query
    alias pqd="pq -d"   # only show packages installed as dependencies
    alias pqe="pq -e"       # show explicitly installed packages
    alias pqi="pq -i"       # show information about an installed package
    alias pql="pq -l"       # show files installed by a package
    alias pqm="pq -m"   # list foreign packages
    alias pqo="pq -o"       # search for package that owns the file
    alias pqs="pq -s"       # search installed packages
    alias psi="pS -i"       # show information about a non-local package
    alias pss="p -Ss"   # query database
    alias pG="p -G"       # get pkgbuild
    alias pqg="p -Qg | sed 's/ .*//' | sort | uniq" # list groups of installed packages
    alias psl="p -Sl | grep -i "         # search database for string
    pdate() { expac -t %y.%m.%d-%H:%M '%l %n-%v' | sort -n; }
    pedate() { expac -t %y.%m.%d-%H:%M '%l %n-%v' $(pacman -Qqe) | sort -n; }
    psize(){ expac -HM "%011m\t%n-%-20v\t%10d" $( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n; }

    pqk() { [[ $# = 0 ]] && pacman -Qk | grep -v '0 missing' || pacman -Qk "$@"; }
    if _have yaourt; then
        alias y="yaourt"
        alias yS="y -S"    # install
        alias yR="y -R"    # remove
        yG() { cd ~/code/build &>/dev/null && yaourt -G $1 && cd $1; }
        alias ysw="y -Sw"      # download but don't install
        alias yss="y -Sas"     # query database
        [[ $_isroot = false ]] && alias ysu="y -Sau" || alias ysu="y -Sau"
    fi
fi

bakh() { # create backup here
    for f in "$@"; do
        f="$(echo "$f" | sed 's!/\+$!!')"   # strip trailing slashes
        g="$(echo "$f" | sed 's/^\.//')" # strip leading dot
        command cp -ai "$f" ."$g-$(date +'%Y%m%d-%H%M')"
    done
}
cdiff() { diff -udrP "$1" "$2" > diff.$(date "+%Y-%m-%d")."$1"; }
dirsize() { # show size of all directories in current working directory
    du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
    egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
    egrep '^ *[0-9.]*M' /tmp/list
    egrep '^ *[0-9.]*G' /tmp/list
    rm /tmp/list
}
# Find
f() { find 2>/dev/null | grep -is "$1"; }
fd() { find "$1" 2>/dev/null | grep -is "$2"; }
ff() { find {.[a-zA-Z],}* -type f 2>/dev/null | xargs grep -is --color=none -n "$@" 2>/dev/null; }
ffd() { find "$1" -type f 2>/dev/null | xargs grep -is --color=none -n "$2"  2>/dev/null; }
fe() { find -L . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;; }
fed() { find $1 -type f -iname '*'${2:-}'*' -exec ${3:-file} {} \;; }
files() { ls -Al $1 | wc -l; }
filessub() { # shows amount of items in subdirs
    for f in $(ls -a); do
        if [[ -d "$f" ]]; then
            echo "$f $(ls "$f" | wc -l)"
        fi
    done | sort -k 2 -n -r
}

##
lsi() {
    if [[ $# == 0 ]];then
        ls ~i
    else
        ls ~i | grep -is "$@"
    fi
}
lsm() {
    if [[ $# == 0 ]];then
        ls ~mov
    else
        ls ~mov | grep -is "$@"
    fi
}
lss() {
    if [[ $# == 0 ]];then
        ls ~ser
    else
        ls ~ser | grep -is "$@"
    fi
}
##

fp() { find $(sed 's/:/ /g' <<<$PATH) 2>/dev/null | grep -is --color $1; } # find in path
goto() { [[ -d "$1" ]] && cd "$1" || cd "$(dirname "$1")"; }
cpg() { cp "$@" && goto "$_"; }
mvg() { mv "$@" && goto "$_"; }
mdg() { mkdir -p "$@" && goto "$_"; }
rmg() { rm "$@" && goto "$_"; }
rdg() { rmdir "$@" && goto "$_"; }
swap() { # swap filenames
  local TMPFILE=/tmp/tmp.$$
  mv $1 $TMPFILE
  mv $2 $1
  mv $TMPFILE $2
}
wgp() { wgetpaste -X "$@"; }
# kill awesome wm dropdown terminals
kdrop() { for i in $(ps aux | grep urxvt_drop | awk '{print $2}'); do kill $i; done; }
#}}}
#{{{ USER ALIASES AND FUNCTIONS
## ps
alias pa="ps -efH"                               # all processes, in hierarchy and full-format listing
alias pag="ps aux | grep -v grep | grep"         # search process
alias pam="echo '%CPU %MEM   PID COMMAND' && /bin/ps hgaxo %cpu,%mem,pid,comm | sort -nrk1 | head -n 10 | sed -e 's/-bin//' | sed -e 's/-media-play//'"
pan() { ps -Ao rss,vsize,cmd | grep $1 | awk '{rss+=$1;virt+=$2}END{print "COUNT: " NR; print "RESIDENT: " int(rss/1024) " MB"; print "VIRTUAL: " int(virt/1024) " MB"}'; }

alias pac0="ps aux | sort -k 3,3 | tail "        # list processes by cpu usage
alias pac1='ps -eo pcpu,nice,stat,time,pid,cmd --sort=-pcpu,-time | sed "/^ 0.0 /d"'
alias par0="ps aux | sort -k 4,4 | tail "        # list processes by memory usage
alias par1='ps -eo rss,vsz,pid,cmd --sort=-rss,-vsz | awk "{ if (\$1 > 10000) print }"'
psmine() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

## cd
alias cdboot="cd /boot"
alias cdetc="cd /etc"
alias cdmnt="cd /mnt"
alias cdsrv="cd /srv"
alias cdt="cd /tmp"
alias cdusr="cd /usr"
alias cdvar="cd /var"
alias cdmed="cd /media"
alias cdconf="cd ~conf"
alias cdbak="cd ~bak"
alias cddown="cd ~down"
alias cdwp="cd ~wp"
alias cdscr="cd ~scr"
alias cdbox="cd ~box"
alias cds="cd ~s"
alias cdaus="cd ~aus"
alias cdbew="cd ~bew"
alias cdlin="cd ~lin"
alias cdfun="cd ~fun"
alias cdbin="cd ~bin"
alias cdcode="cd ~code"
alias cdbuild="cd ~build"
alias cdlearn="cd ~learn"
alias cddoc="cd ~docs"
alias cdgit="cd ~git"
alias cdawe="cd ~awe"
alias cdawet="cd ~awet"
alias cdthemes="cd ~themes"
alias cdmpd="cd ~mpd"
alias cdmpdpl="cd ~mpdpl"
alias cdhd="cd ~demian"
alias cdhs="cd ~slave"
alias cdcache="cd ~cache"
alias cdlog="cd ~log"
alias cdlogs="cd ~logs"
alias cdhttp="cd ~http"
alias cdmed="cd ~med"
alias cdm="cd ~m"
alias cdg="cd ~g"
alias cdi="cd ~i"
alias cdmov="cd ~mov"
alias cdser="cd ~ser"
alias cdsh="cd ~sh"
alias cdshare="cd ~share"
alias cdhs="cd ~hs"
alias cdhd="cd ~hd"
if [[ $HOST = laptop ]];then
    alias cdbat="cd ~BAT"
    alias cdbright="cd ~bright"
    alias cdacpi="cd ~acpi"
fi

## chown, chmod
alias cm="chmod"                 # chmod
alias chr="chmod a+r"                            # add read permissions for all users
alias chw="chmod a+w"                            # add write permissions for all users
alias co="chown"                 # chown
alias cx="chmod a+x"                             # make file executable for everyone
grab() { sudo chown -R ${USER}:${USER} ${1:-.}; }
sanitize() { # change mode and users of files to safe default
    chmod -R u=rwX,go=rX "$@"
    chown -R ${USER}:users "$@"
}

# edit configs
alias vn="v $HOME/.note"                        # visual edit notes (also see function note() below)
alias vnn="v $HOME/.notemed"
alias vz="v $HOME/.zshrc"                        # visual edit zsh files
vs() { cp -iv $1 ${1}.backup && $VISUAL $1; }

## user
alias irc="weechat-curses"
alias sdr="screen -D -R $1"                          # if session is running, reattach. if necessary detach and logout remotely first. if it was not running create it and notify the user.
alias sls="screen -ls"                               # lists pid.tty.host strings
alias ss="screen -S $1"                              # start session specifying a name
alias tsh="tmux split -h"
alias tsv="tmux split"
alias watchcpu="watch -n .5 grep \'cpu MHz\' /proc/cpuinfo"
myip() {
    #lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | awk '{ print $4 }' | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g'
    lynx -dump http://tnx.nl/ip
}
freem() { free -m | grep 'Mem:' | awk '{print $4}'; }
#flac2mp3() { for file in *.flac; do $(flac -cd "$file" | lame -h - "${file%.flac}.mp3"); done; }
ghost() { urxvt -name urxvt_ghost -e ghost; }
ghostwlan() { cd ~/ghost && ./ghost++ ghostwlan.cfg; }

## code
alias lc="wc -l"
alias raw='grep -Ev "^\s*(;|#|$)"'
alias rawlc="grep -cv '^#\|^$'"
alias lsc="ls **/*.c~(*/)#SCCS/*"   # list .c files (except those in SCCS directories)
alias lsch="ls **/*.(c|h)"
alias lsreadme="ls **/*(#ia2)readme"    # list all README files in all subdirs
alias lsR="ls -l *(R)"

alias makepkgg="makepkg -g >> PKGBUILD"
alias gitpush="git push origin master"
alias gitlog="git log --pretty=oneline --abbrev-commit"
alias gits="git status -s"
debug() { # run bash script in 'debug' mode
    local script="$1"; shift

    bash -x $(which $script) "$@"
}

## space
space() { # create report of biggest files in folder $@
    echo Creating report of biggest files in folder $1
    du -h "$@" | sort -nr > $HOME/.logs/spacereport.txt && vim $HOME/.logs/spacereport.txt
    echo Saved as $HOME/.logs/spacereport.txt
}

## archives
ac() { # compress to archive
    case "$1" in
        tar.bz2|.tar.bz2) tar cvjf "${2%%/}.tar.bz2" "${2%%/}/" ;;
        tbz2|.tbz2)       tar cvjf "${2%%/}.tbz2" "${2%%/}/"    ;;
        tbz|.tbz)         tar cvjf "${2%%/}.tbz" "${2%%/}/"     ;;
        tar.gz|.tar.gz)   tar cvzf "${2%%/}.tar.gz" "${2%%/}/"  ;;
        tar.Z|.tar.Z)     tar Zcvf "${2%%/}.tar.Z" "${2%%/}/"   ;;
        tgz|.tgz)         tar cvjf "${2%%/}.tgz" "${2%%/}/"     ;;
        tar|.tar)         tar cvf  "${2%%/}.tar" "${2%%/}/"     ;;
        rar|.rar)         rar a "${2%%/}.rar" "${2%%/}/"        ;;
        zip|.zip)         zip -r9 "${2}.zip" "$2"           ;;
        7z|.7z)       7z a "${2}.7z" "$2"           ;;
        lzo|.lzo)         lzop -v "$2"              ;;
        gz|.gz)       gzip -v "$2"              ;;
        bz2|.bz2)         bzip2 -v "$2"             ;;
        xz|.xz)       xz -v "$2"                ;;
        lzma|.lzma)       lzma -v "$2"              ;;
        *)             echo "Error, please go away.";;
    esac
}
ad() { # decompress archive
    if [[ -f "$@" ]] ; then
        case "$@" in
            *.tar.bz2)   tar xvjf "$@"        ;;
            *.tar.gz)    tar xvzf "$@"     ;;
            *.bz2)       bunzip2 "$@"       ;;
            *.rar)       unrar x "$@"     ;;
            *.gz)        gunzip "$@"     ;;
            *.tar)       tar xvf "$@"        ;;
            *.tbz2)      tar xvjf "$@"      ;;
            *.tgz)       tar xvzf "$@"       ;;
            *.zip)       unzip "$@"     ;;
            *.Z)         uncompress "$@"  ;;
            *.7z)        7z x "$@"    ;;
            *)           echo "$@ cannot be decompressed" ;;
        esac
    else
        echo "Not a file"
    fi
}
al() { # list archive content
    case "$1" in
        *.tar.bz2|*.tbz2|*.tbz)  tar -jtf "$1"   ;;
        *.tar.gz|*.tar.Z)            tar -ztf "$1"   ;;
        *.tar|*.tgz)         tar -tf "$1"    ;;
        *.gz)                gzip -l "$1"    ;;
        *.rar)               rar vb "$1"     ;;
        *.zip)               unzip -l "$1"   ;;
        *.7z)                7z l "$1"   ;;
        *.lzo)               lzop -l "$1"    ;;
        *.xz|*.txz|*.lzma|*.tlz)     xz -l "$1"  ;;
        *)               echo "Error, please go away.";;
    esac
}

## little helpers
del() { # manage trash can
    if [[ -z $1 ]]; then
        ls -a $HOME/.local/trash
        echo -n "Empty Trash? (y/n)"
        if read -q; then
            rm -rf $HOME/.local/trash/*
            echo "Emptied trash."
        else
            echo "Doing nothing."
        fi
    elif [[ -f $1 ]]; then
        echo "Delete or just move to trash? (d/t)?"
        read var
        if [[ $var = t ]]; then
            mv -v $1 $HOME/.local/trash/
        elif [[ $var = d ]]; then
            rm -rI $1
        else
            echo 'The requested file/folder, $1, does not exist'
        fi
    fi
}
notemed() { # for media related notes, movies, tv shows, music ...
    [[ -f $HOME/.notemed ]] || touch $HOME/.notemed
    if [[ $# = 0 ]];then
        cat $HOME/.notemed | tail -n 20
    elif [[ $1 = -c ]];then
        > $HOME/.notemed
    else
        echo "$@" >> $HOME/.notemed
    fi
}
note() { # random notes
    [[ -f $HOME/.note ]] || touch $HOME/.note
    if [[ $# = 0 ]];then
        cat $HOME/.note | tail -n 20
    elif [[ $1 = -c ]];then
        > $HOME/.note
    else
        echo "$@" >> $HOME/.note
    fi
}

mkiso() { # create an ISO image
    if [[ $# -eq 0 ]]; then
        printf "usage: iso <file>, ...\n" >&2
        exit 1
    fi

    tmp=/tmp/iso
    mkdir -p "$tmp"

    for file; do
        ln -s "$(readlink -f "$file")" "$tmp"
    done

    mkisofs -o ./files.iso -f -r -J -l -allow-leading-dots "$tmp"
}
res() { # resize a picture to 1920 x 1200 at 90% quality
    #no arguments, print usage
    if [[ $# = 0 ]];then
        echo "Usage: res filename"
        echo "Example: res P103845.JPG"
    else
        echo "Resizing ${i:2} to 1920 x 1200 at 90% quality with filename res-$1";convert -resize 1920x1200 -quality 90 $1 res-$1
    fi
}
resa() { # resize and replace all pictures in a directory
    #no arguments, print usage
    if [[ $# = 0 ]];then
        echo "Usage: resa width height quality"
        echo "Example: resa 1920 1200 90"
    else
        for i in $(find . -maxdepth 1 -type f \-iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.bmp"); do
            echo "Resizing ${i:2} to $1 x $2 at $3% quality";convert ${i:2} -quality $3 -resize $1\x$2 new_${i:2}; /bin/mv new_${i:2} ${i:2}
        done
    fi
}
ress() { # resize a single picture specifying width, height, quality and filename
    #no arguments, print usage
    if [[ $# = 0 ]];then
        echo "Usage: ress width height quality filename"
        echo "Example: ress 1920 1200 90 P103845.JPG"
    else
        echo "Resizing ${i:2} to $1 x $2 at $3% quality with filename ress-$4";convert -resize $1\x$2 -quality $3 $4 ress-$4
    fi
}
shot() { # create a screenshot with thumbnail in specified folder
    local PIC="${HOME}/.local/screenshots/%d.%m.%y_%H-%M-%S.jpg"
    scrot -q 90 $PIC
}
shotw() { # create a screenshot of a window
    local PIC="${HOME}/.local/screenshots/w_%d.%m.%y_%H-%M-%S.jpg"
    scrot -s -q 90 $PIC
}
passgen1() {
    local l=$1
        [ "$l" == "" ] && l=16
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}
passgen2() {
    local l=$1
    [[ $# = 0 ]] && l=11
    openssl rand -base64 $l
}
if _have pomshot;then
    pomshotc() {
        cd ~scr >/dev/null
        [[ -n $1 ]] && countdown $1 || countdown 5
        pomshot
    }
fi
if _have pomit;then #FIXME TODO
    pomshotw() {
        cd ~scr >/dev/null
        sleep 1
        pomshot -q 90 -bs
    }
fi
if _have mogrify;then
    thumb2() {
        for pic in "$@"; do
            case "$pic" in
                *.jpg)  thumb="${pic/.jpg/-thumb2.jpg}"   ;;
                *.jpeg) thumb="${pic/.jpeg/-thumb2.jpeg}" ;;
                *.png)  thumb="${pic/.png/-thumb2.png}"   ;;
                *.bmp)  thumb="${pic/.bmp/-thumb2.bmp}"   ;;
            esac
            [[ -z "$thumb" ]] && return 1
            cp "$pic" "$thumb" && mogrify -resize 20% "$thumb"
        done
    }
    thumb4() {
        for pic in "$@"; do
            case "$pic" in
                *.jpg)  thumb="${pic/.jpg/-thumb4.jpg}"   ;;
                *.jpeg) thumb="${pic/.jpeg/-thumb4.jpeg}" ;;
                *.png)  thumb="${pic/.png/-thumb4.png}"   ;;
                *.bmp)  thumb="${pic/.bmp/-thumb4.bmp}"   ;;
            esac
            [[ -z "$thumb" ]] && return 1
            cp "$pic" "$thumb" && mogrify -resize 20% "$thumb"
        done
    }
    thumb250() {
        for pic in "$@"; do
            case "$pic" in
                *.jpg)  thumb="${pic/.jpg/-thumb4.jpg}"   ;;
                *.jpeg) thumb="${pic/.jpeg/-thumb4.jpeg}" ;;
                *.png)  thumb="${pic/.png/-thumb4.png}"   ;;
                *.bmp)  thumb="${pic/.bmp/-thumb4.bmp}"   ;;
            esac
            [[ -z "$thumb" ]] && return 1
            cp "$pic" "$thumb" && mogrify -resize 250x250 "$thumb"
        done
    }
fi

## functions providing information
cal() { # print a calender in terminal
    if [[ ! -f /usr/bin/cal ]] ; then
        echo "Error, you need the package util-linux-ng"
        return 1
    elif [[ "$#" = "0" ]] ; then
        /usr/bin/cal | egrep -C 40 --color "\<$(date +%e| tr -d ' ')\>"
        echo "Today is `da`"
    else
        cal $@ | egrep -C 40 --color "\<($(date +%B)|$(date +%e | tr -d ' '))\>"
        echo "Today is `da`"
    fi
}
color1() {
    initializeANSI() {
        esc=""

        blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
        yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
        cyanf="${esc}[36m";    whitef="${esc}[37m"

        blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
        yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
        cyanb="${esc}[46m";    whiteb="${esc}[47m"

        boldon="${esc}[1m";    boldoff="${esc}[22m"
        italicson="${esc}[3m"; italicsoff="${esc}[23m"
        ulon="${esc}[4m";      uloff="${esc}[24m"
        invon="${esc}[7m";     invoff="${esc}[27m"

        reset="${esc}[0m"
    }

    # note in this first use that switching colors doesn't require a reset
    # first - the new color overrides the old one.

    initializeANSI

cat << EOF

 ${redf}▆▆▆▆▆▆▆▆▆▆${reset} ${greenf}▆▆▆▆▆▆▆▆▆▆${reset} ${yellowf}▆▆▆▆▆▆▆▆▆▆${reset} ${bluef}▆▆▆▆▆▆▆▆▆▆${reset} ${purplef}▆▆▆▆▆▆▆▆▆▆${reset} ${cyanf}▆▆▆▆▆▆▆▆▆▆${reset}
 ${boldon}${blackf} :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${reset}
 ${boldon}${redf}▆▆▆▆▆▆▆▆▆▆${reset} ${boldon}${greenf}▆▆▆▆▆▆▆▆▆▆${reset} ${boldon}${yellowf}▆▆▆▆▆▆▆▆▆▆${reset} ${boldon}${bluef}▆▆▆▆▆▆▆▆▆▆${reset} ${boldon}${purplef}▆▆▆▆▆▆▆▆▆▆${reset} ${boldon}${cyanf}▆▆▆▆▆▆▆▆▆▆${reset}

EOF

}

color2() {
    T='gYw'   # The test text
    #T='▆ ▆'
    echo -e "\n                 40m     41m     42m     43m\
     44m     45m     46m     47m";

    for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
           '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
           '  36m' '1;36m' '  37m' '1;37m';
        do FG=${FGs// /} echo -en " $FGs \033[$FG  $T  "
            for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
                do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
            done
        echo;
    done
    echo
}
timer() {
    if [[ -z "$1" ]];then
        echo "timer <time> <message>"
    else
        (sleep "$1"; shift
        zenity --info --title="Timer" --text="$@")&
    fi
}
sysinfo() { # show information about my system
    clear
    num_cpus=$(cat /proc/cpuinfo | grep -c "model name")
    machine_cpu=$(cat /proc/cpuinfo | grep -m 1 "model name" | cut -d: -f2)
    machine_mhz=$(cat /proc/cpuinfo | grep -m 1 "cpu MHz" | cut -d: -f2)
    machine_cpuinfo=$(uname -mp)
    todays_date=$(date +"%D %r")
    machine_uptime=$(uptime)
    machine_ram=$(cat /proc/meminfo | grep -m 1 "MemTotal:" | cut -d: -f2 |  sed 's/^[ \t]*//')
    machine_video=$(lspci | grep -m 1 "VGA" | cut -d: -f3 |  sed 's/^[ \t]*//')
    machine_eth_card=$(lspci | grep -m 1 "Ethernet" | cut -d: -f3 |  sed 's/^[ \t]*//')
    machine_audio_controller=$(lspci | grep -m 1 "audio" | cut -d: -f3 |  sed 's/^[ \t]*//')
    last_logins=$(last | head)
    ethinfo=$(ifconfig enp0s25 | grep "inet " | sed 's/inet addr/Local IP/g' | sed 's/^[ \t]*//;s/[ \t]*$//')
    wlaninfo=$(ifconfig wls1 | grep "inet " | sed 's/inet addr/Local IP/g' | sed 's/^[ \t]*//;s/[ \t]*$//')
    echo "ARCH LINUX - Machine Information Script ver .10"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "DATE: $todays_date   MACHINE NAME: $(hostname)  "
    echo " "
    [[ -z $wlaninfo ]] && echo "wlan: not connected" || echo "wlan: $wlaninfo"
    [[ -z $ethinfo ]] && echo "eth: not connected" || echo "eth: $ethinfo"
    echo "ETHERNET CARD: $machine_eth_card"
    echo "CPU INFO: Qty=$num_cpus $machine_cpuinfo"
    echo "VIDEO CARD: $machine_video"
    echo "AUDIO CONTROLLER: $machine_audio_controller"
    echo "RAM INFO: $machine_ram"
    echo " "
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    [[ -n $wlaninfo || -n $ethinfo ]] && route
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "DISK USAGE:"
    df -h
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "UPTIME: $machine_uptime"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}
#}}}
#{{{ CONDITIONAL
### laptop?
if [[ $HOST != slave ]]; then
    # commons
    export acpi=/sys/devices/platform/thinkpad_acpi
    export bat=/sys/devices/platform/smapi/BAT0
    export bright=/sys/class/backlight/acpi_video0/brightness
    export bt=/sys/devices/platform/thinkpad_acpi/bluetooth_enable

    echoparm() { # $1: file, $2: n/a message, $3: unit, $4: cutoff
        local val
        if [[ -f $1 ]]; then
            val=$(cat $1)
            [[ -n "$4" ]] && val=${val%$4}
            [[ -n "$3" ]] && echo "$1 = $val [$3]" || echo "$1 = $val"
        else
            [[ -n "$2" ]] && echo "$1 = ($2)" || echo "$1 = (n/a)"
        fi
    }

    # Gnuplot
    alias cdplt="cd ~/.plot"

    # battery
    watt() { [[ -d $bat ]] && cat $bat/power_now || cat /proc/acpi/battery/BAT0/state | awk 'NR==4 {print $3}'; }
    alias wattwatch="watch -n1 cat ~bat/power_now"
    alias cdacpi="cd $acpi"
    alias bata="cat /proc/acpi/battery/BAT0/state"
    alias bat0="bat -b 0"
    batc(){
        if [[ $# = 0 ]];then
            echo $(cat ~bat/start_charge_thresh)-$(cat ~bat/stop_charge_thresh)
        elif [[ -n $2 && $2 != *[!0-9]* ]];then
            echo $1 | sudo tee $bat/start_charge_thresh
            echo $2 | sudo tee $bat/stop_charge_thresh
        elif [[ -n $1 && $1 != *[!0-9]* ]];then
            echo $1 | sudo tee $bat/start_charge_thresh
        else
            echo "Usage: batc 50 [90]"
        fi
    }
    alias bath="bat0 | grep -A 4 'Battery health'"
    alias bats="bat0 | grep -A 6 'Battery status'"
    batinfo() {
        echoparm $bat/state
        echoparm $bat/remaining_percent "" %
        echoparm $bat/remaining_running_time "" min
        echoparm $bat/remaining_running_time_now "" min
        echoparm $bat/power_now "" mW
        echoparm $bat/power_avg "" mW
    }
    batcharge() {
        echoparm $bat/state
        echoparm $bat/remaining_percent "" %
        echoparm $bat/remaining_capacity "N/A" mW
        echoparm $bat/remaining_charging_time "" min
        echoparm $bat/last_full_capacity "" mW
        echoparm $bat/start_charge_thresh "" %
        echoparm $bat/stop_charge_thresh "" %
    }

    batset() {
        if [[ $# = 0 ]];then
            echoparm $bat/start_charge_thresh
            echoparm $bat/stop_charge_thresh
        else
            echo $1 | sudo tee $bat/start_charge_thresh
            echo $2 | sudo tee $bat/stop_charge_thresh
        fi
    }

    # brightness
    trapped() {
        echo -en "\nHelligkeit: $(cat $bright)\n"
    }
    hell+() {
        trap "trapped && return 0" SIGINT
        while true; do sleep .5 && hell +; done
    }
    hell-() {
        trap "trapped && return 0" SIGINT
        while true; do sleep .5 && hell -; done
    }

    # fan control
    fan() { # control fan
        fanfile=/proc/acpi/ibm/fan
        case "$1" in
            on|auto)      echo level auto | sudo tee $fanfile;;
            0|off|disable)    echo disable | sudo tee $fanfile;;
            '')       cat $fanfile;;
            dog)      echo watchdog 120 | sudo tee $fanfile;;
            *)        echo level $@ | sudo tee $fanfile;;
        esac
    }
    temp() { cat /proc/acpi/ibm/thermal | awk '{print $2, $3, $5, $6, $8, $10, $11}'; }
    
    # network
    alias iwconfig="sudo iwconfig"
    alias iwcfg="iwconfig"
    alias ifcfg="ifconfig"
    alias iwpower="iwconfig wls1 power"
    alias iwlist="sudo iwlist"
    alias iwconfig="sudo iwconfig"
    alias iwpower="iwconfig wls1 power"
    alias iwscan="iwlist wls1 scan | iwscanparse"
    alias iwscan2="iwlist wls1 scan | grep -B 3 ESSID"

    alias rfkill="sudo rfkill"
    alias lsnet="netctl list | awk '/*/ {print $2}'"
    alias wbl="rfkill block wlan"
    alias won="ifconfig wls1 up"
    alias woff="ifconfig wls1 down"
    alias eon="ifconfig enp0s25 down"
    alias eoff="ifconfig enp0s25 up"
    alias bon="echo 1 | sudo tee $bt"
    alias boff="echo 0 | sudo tee $bt"
    alias wubl="rfkill unblock wlan ; ifconfig wls1 up"

    #  profiles
    alias netctl="sudo netctl"
    alias alldown="netctl store; netctl stop-all"
    alias allup="netctl restore"

    alias bup="netctl start bett"
    alias fup="netctl start felix"
    alias hup="netctl start home"
    alias uup="netctl start uni"
    alias pup="netctl start petra"

    alias bdown="netctl stop bett"
    alias fdown="netctl stop felix"
    alias hdown="netctl stop home"
    alias udown="netctl stop uni"
    alias pdown="netctl stop uni"

    alias breup="netctl restart bett"
    alias freup="netctl restart felix"
    alias hreup="netctl restart home"
    alias ureup="netctl restart uni"
    alias preup="netctl restart petra"

    lid(){
        local onstate="systemctl suspend;;#"
        local offstate=";;#systemctl suspend"
        local file=/etc/acpi/handler.sh
        state(){ grep -c "$onstate" "$file"; }
        if [[ $1 == on ]];then
            sudo sed -i "s/$offstate/$onstate/g" "$file"
            [[ $(state) = 1 ]] && echo "success"
        elif [[ $1 == off ]];then
            sudo sed -i "s/$onstate/$offstate/g" "$file"
            [[ $(state) = 0 ]] && echo "success"
        else
            [[ $(state) = 1 ]] && echo "On" || echo "Off"
        fi
    }
    alias wol2="wol 40:61:86:87:F3:FE"
    alias wol2i="wol -i 192.168.0.2 40:61:86:87:F3:FE"
    alias ssh2="ssh -p 21397 slave@htpc"
    alias s2off="ssh -p 21397 slave@htpc 'DISPLAY=:0 xset dpms force off'"
    alias s2on="ssh -p 21397 slave@htpc 'DISPLAY=:0 xset dpms force on'"
    alias v2off="ssh -p 21397 slave@htpc 'DISPLAY=:0 sudo vbetool dpms off'"
    alias v2on="ssh -p 21397 slave@htpc 'DISPLAY=:0 sudo vbetool dpms on'"
    bla(){ ssh -p 21397 slave@htpc 'pkill -USR1 -f "python2.*blockify"'; }
    blr() { ssh -p 21397 slave@htpc 'pkill -USR2 -f "python2.*blockify"'; }
    bls() { ssh -p 21397 slave@htpc 'pkill -f "python2.*blockify"'; }
    alias blget="ssh -p 21397 slave@htpc 'spotifycmd status | grep -v OK'"
    blsr() { ssh -p 21397 slave@htpc 'pkill spotify; wspotify'; } #FIXME

    # shares
    alias umnti="cd && sleep .1 && umount -fl ~i"
    alias umntser="cd && sleep .1 && umount -fl ~ser"
    alias umntmov="cd && sleep .1 && umount -fl ~mov"
    umnta(){ (umntm; umnti; umntser; umntmov)&>/dev/null; }
    alias umntm="cd && sleep .1 && umount -fl /mnt/smb"
    #alias mntm="mount /mnt/smb && cdm"
    alias mntm="mount -o guest,gid=1000,uid=1000 //192.168.0.2/media ~/media && sleep .1 && cd ~/media"
    alias mntm="mount -t nfs htpc: ~/media && sleep .1 && cd ~/media"
    alias mnta="(mntmov;mntser;mnti)&>/dev/null && cdi"
    alias mnti="mount -o guest,gid=1000,uid=1000 //192.168.0.2/incoming ~i && sleep .1 && cdi"
    alias mntser="mount -o guest,gid=1000,uid=1000 //192.168.0.2/ser ~ser && sleep .1 && cdser"
    alias mntmov="mount -o guest,gid=1000,uid=1000 //192.168.0.2/mov ~mov && sleep .1 && cdmov"
    alias mntshare="mount -o guest,gid=1000,uid=1000 //192.168.0.2/share ~share && sleep .1 && cdshare"
else
    [[ $_isroot == false ]] && alias netctl="sudo netctl"
    alias hup="netctl start home"
    alias bla="pkill -USR1 -f python2.*blockify"
    alias blr="pkill -USR2 -f python2.*blockify"
    alias bls="pkill -f python2.*blockify"
    alias blsr="pkill spotify && wspotify"
    alias blget="spotifycmd status | grep -v OK"
    alias hdown="netctl stop home"
    alias hreup="netctl restart home"
fi

### DISPLAY?
if [[ $_isxrunning = true ]]; then
    ## exports
    export  LEDITOR="urxvt -e vim -p "           \
            OFFICE=libreoffice               \
            PDF=evince                   \
            PICSHOW=eog             \
            VIDEO=vlc

    ## Wine
    #_have wine && alias wc3='wine "/mnt/wc3/Frozen Throne.exe" -opengl'
    #alias ghost='urxvt -name urxvt_ghost -e "~/ghostcb/./ghost++"'

    ## various
    alias pc="q eog"
    alias pdf="q evince"
    alias session="q session"                            # .bin/session
    alias vo="v $HOME/.config/openbox/{autostart.sh,menu.xml,rc.xml}" # visual edit openbox files
    ## functions
    alias se="sudo e"
    #alias sm="sudo m"
    ses() { sudo cp -iv "$1" ${1}.backup && sudo $XEDITOR "$1"; }

    if _have awmtt; then
        alias awc="awmtt"
        alias awcn="awc start -N"
    fi
    alias soff="xset dpms force off"
    alias voff="sudo vbetool dpms off"
    alias von="sudo vbetool dpms on"
    togglecomp() {
        if  [[ -z $(pgrep compton) ]] ; then
            echo "Turning composition ON"
            compton &
        else
            echo "Turning xcompmgr OFF"
            pkill compton &
        fi
    }

    if [[ $shell = zsh ]];then
        alias eb="gvim $HOME/.zshrc"
        alias mb="m $HOME/.zshrc"
    fi
    alias e="$LEDITOR"
    alias en="e $HOME/.note"
    ggl() {
        if [[ -z "$XBROWSER" ]];then
            local term="${*:-$(xclip -o)}"
            $BROWSER "http://www.google.com/search?q=${term// /+}"
        else
            local term="${*:-$(xclip -o)}"
            $XBROWSER "http://www.google.com/search?q=${term// /+}"
        fi
    }

    alias m="geany"
    alias mnew="m -n"
    alias mn="m $HOME/.note"
    alias mnn="m $HOME/.notemed"
    _have xprop && alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""' || alias xp="obxprop | grep OB_APP_CLASS"
    _have xev && keycode(){ xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'; }
    propstring () {
        echo -n 'Property '
        xprop WM_CLASS | sed 's/.*"\(.*\)", "\(.*\)".*/= "\1,\2" {/g'
        echo '}'
    }
    es() { cp -iv $1 ${1}.backup && $EDITOR $1; }
fi
#}}}
if _have awesome;then
    alias ea="e $HOME/.config/awesome/rc.lua"
    alias ma="m $HOME/.config/awesome/rc.lua"
    alias ga="g $HOME/.config/awesome/rc.lua"
    alias aex="killall awesome"
    alias are="echo 'awesome.restart()' | awesome-client"
    # just an example to remember:
    apipe() { echo 'return require("awful").util.getdir("config")' | awesome-client; }
fi

# stream & record
twitch() { # stream my shit on twitch
    [[ -z "$INRES" ]] && INRES=1440x900               # input resultion
    [[ -z "$OUTRES" ]] && OUTRES=1440x900         # output resolution
    [[ -z "$FPS" ]] && FPS=30
    [[ -z "$SERVER" ]] && SERVER=live-fra         # in doubt put live
    [[ -z "$TWITCHKEY" ]] && TWITCHKEY=$(cat ~/.twitchkey)  # your broadcast key in a file
    [[ -z "$TOPXY" ]] && TOPXY="0,0"                # screen region. 0,0 = whole screen
    [[ -z "$GETX" ]] && GETX=${TOPXY%%,*}
    [[ -z "$AUDIOSRC" ]] && AUDIOSRC="hw:0,0"     # audio source. alsa e.g. hw:0,0, pulse = pulse
    [[ -z "$PRESET" ]] && PRESET=veryfast         # your x264 ffmpeg preset file
    [[ -z "$THREADS" ]] && THREADS=2                # 4 or 6 for good CPUs

    # -vf scale=$GETX:-1
    # for audio add: -f alsa -ac 2 -i "$AUDIOSRC" -b:v 650k -b:a 64k -acodec libmp3lame -ar 44100 -ab 64k
    ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0+"$TOPXY" -ss 2 -vcodec libx264 -preset "$PRESET" -pix_fmt yuv420p -threads "$THREADS" -f flv rtmp://"$SERVER".justin.tv/app/"$TWITCHKEY"
}
twitchw() { # stream (only) a selected screen region
    emulate -L zsh
    source <(awk 'TOPXY[FNR]=$4 {next} ; INRES[FNR]=$2 {next}; END { print "TOPXY="TOPXY[8]","TOPXY[9]; print "INRES="INRES[12]"x"INRES[13] }' < <(xwininfo))
    twitch
}
alias soundrecord="ffmpeg -f alsa -ac 2 -i hw:0 -vn -acodec libmp3lame -ab 196k capture.mp3"
alias soundtest="aplay /usr/share/sounds/alsa/Front_Center.wav"

#{{{ ZSH
if [[ $shell != zsh ]];then
    alias sudo="sudo "
    alias s="sudo"
    bash_prompt() {
        h1=${HOST:0:1}
        if [[ $HOST == laptop ]];then
            PS1="\[\033[0;34m\] >>\[\033[0m\] "
            [[ $EUID = 0 ]] && PS1="\[\033[0;31m\] #\[\033[0m\] "
        else
            PS1="\[\033[0;32m\] $h1$h1\[\033[0m\] "
            [[ $EUID = 0 ]] && PS1="\[\033[0;32m\] $h1\[\033[0;31m\]#\[\033[0m\] "
        fi
    }
    bash_prompt
else
    # report time for any command that takes longer than 5 seconds
    export REPORTTIME=5
    # by default: export WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
    # we take out the slash, period, angle brackets, dash here.
    #export WORDCHARS='*?_[]~=&;!#$%^(){}'

    ## general options
    setopt  NO_BEEP         \
            NO_CASE_GLOB      \
            GLOB          \
            EXTENDED_GLOB \
            NO_DOT_GLOB       \
            NUMERIC_GLOB_SORT \
            MARK_DIRS     \
            NO_NOMATCH        \
            ALWAYS_LAST_PROMPT    \
            NO_CLOBBER        \
            HASH_CMDS     \
            HASH_DIRS     \
            HASH_LIST_ALL \
            IGNORE_EOF        \
            INTERACTIVE_COMMENTS  \
            NO_PRINT_EXIT_VALUE   \
            MULTIOS       \
            AUTO_REMOVE_SLASH \
            AUTO_CONTINUE \
            LONG_LIST_JOBS    \
            NO_BG_NICE        \
            NO_CHECK_JOBS     \
            NO_HUP            \
            NO_NOTIFY     \
            INTERACTIVE_COMMENTS  \
            MAGICEQUALSUBST       \
            NO_TRANSIENT_RPROMPT
    ## history
    export  HISTFILE=$HOME/.zhistory \
            HISTSIZE=12000       \
            SAVEHIST=12000

    setopt  NO_EXTENDED_HISTORY \
            SHARE_HISTORY    \
            HIST_APPEND      \
            HIST_IGNORE_SPACE    \
            HIST_IGNORE_ALL_DUPS \
            HIST_IGNORE_DUPS \
            PUSHD_IGNORE_DUPS    \
            HIST_SAVE_NO_DUPS    \
            HIST_REDUCE_BLANKS   \
            HIST_IGNORE_SPACE    \
            HIST_REDUCE_BLANKS   \
            INC_APPEND_HISTORY   \
            HIST_NO_STORE
    alias top10='print -l ? ${(o)history%% *} | uniq -c | sort -nr | head -n 10'
    alias top25='print -l ? ${(o)history%% *} | uniq -c | sort -nr | head -n 25'
    ## globals and suffixes
    alias -g ...="../.."
    alias -g ....="../../.."
    alias -g .....="../../../.."
    alias -g GI="| grep"
    alias -g G="| grep -i"
    alias -g GV="| grep -iv"
    alias -g H="| head"
    alias -g Hl=" --help"
    alias -g L="| less"
    alias -g LL="|& less -r"
    alias -g N="&>/dev/null"
    alias -g N1="1>/dev/null"
    alias -g N2="2>/dev/null"
    alias -g S="| sort"
    alias -g T="| tail"
    alias -g TE="| tee"
    alias -g VAR=">>$HOME/.logs/var.txt"
    alias -g WC="| wc -l"
    alias -g XA="| xargs"
    ## Suffixes
    
    if [[ $_isxrunning = true ]];then
        alias -s {conf,txt,TXT,README,PKGBUILD}=$XEDITOR
    else
        alias -s {java,.c,.k,.h,.o}=$LEDITOR
    fi
    alias -s {PDF,pdf}=$PDF
    alias -s {docx,DOCX,doc,DOC,odt,ODT,sxw,ods,xls}=$OFFICE
    alias -s {jpg,JPG,jpeg,JPEG,png,PNG,gif,GIF}=$PICS
    alias -s xcf="q gimp"
    alias -s svg="q inkscape"
    alias -s {MP3,mp3,ogg,wav,WAV,flac,FLAC,mpg,mpeg,avi,AVI,ogm,wmv,m4v,mp4,mov,MOV,mkv,MKV}=$VIDEO
    alias -s {html,htm,php,url,org,de,com,net,uk}="q $XBROWSER"

    #wiki() { for i ($*) q $BROWSER http://en.wikipedia.org/wiki/$(sed 's| |%20|g' <<<$i); }

    ## load
    autoload -Uz compinit zargs zmv colors
    colors
    compinit
    zmodload zsh/complist

    ## autoload and keybinds
    #fpath=/home/demian/.zsh/site-functions:$fpath
    zrcautoload() {
        emulate -L zsh
        setopt extended_glob
        local fdir ffile
        local -i ffound

        ffile=$1
        (( found = 0 ))
        for fdir in ${fpath} ; do
            [[ -e ${fdir}/${ffile} ]] && (( ffound = 1 ))
        done
        (( ffound == 0 )) && return 1
        autoload ${ffile} || return 1
        return 0
    }

    # Load is-at-least() for more precise version checks
    # Note that this test will *always* fail, if the is-at-least
    # function could not be marked for autoloading.
    zrcautoload is-at-least || is-at-least() { return 1; }

    #{{{ KEYBINDS
    typeset -g -A key
    bindkey '^?' backward-delete-char
    bindkey '^[[7~' beginning-of-line
    bindkey '^[[5~' up-line-or-history
    bindkey '^[[3~' delete-char
    bindkey '^[[8~' end-of-line
    bindkey '^[[6~' down-line-or-history
    bindkey '^[[A' up-line-or-search
    bindkey '^[[D' backward-char
    bindkey '^[[B' down-line-or-search
    bindkey '^[[C' forward-char
    bindkey '^[[2~' overwrite-mode
    ##
    bindkey -v
    bindkey "^[OH" beginning-of-line        # home
    bindkey "^[OF" end-of-line              # end
    bindkey "^[[D"  backward-char           # left
    bindkey "^[[C"  forward-char            # right
    bindkey "^[[A"  up-line-or-history      # up
    bindkey "^[[B"  down-line-or-history    # down
    bindkey "^[[3~" delete-char        # del
    bindkey "^[[1;3A" history-beginning-search-backward # alt + up
    bindkey "^[[1;3B" history-beginning-search-forward  # alt + down
    bindkey -M viins "^?" backward-delete-char # traditional backspace
    bindkey -M viins "^H" backward-delete-char
    bindkey "^?" backward-delete-char      # backspace
    bindkey "^[[1;3D" backward-word        # alt + left
    bindkey "^[[1;3C" forward-word         # alt + right
    bindkey "^[[1;2D" beginning-of-line    # shift + left
    bindkey "^[[1;2C" end-of-line          # shift + right
    bindkey "^[[3;3~" delete-word          # alt + delete
    bindkey "^[[3;2~" backward-delete-word     # shift + delete
    bindkey "^[" self-insert           # alt + enter
    bindkey "^z" undo              # ctrl + Z
    bindkey "^L" push-line             # push current command into a buffer, allows you to do another command then returns to previous command
    bindkey " " magic-space            # history expansion on space
    bindkey '^F' forward-word
    bindkey '^B' backward-word
    ## URXVT
    bindkey "^Y" yank
    bindkey "[2~" overwrite-mode
    bindkey "^[[7~" beginning-of-line
    bindkey "^[[8~" end-of-line
    bindkey "^[" delete-word           # alt + delete
    bindkey "[3$" backward-delete-word     # shift + delete
    bindkey "^[^[[A" history-beginning-search-backward # alt + up
    bindkey "^[^[[B" history-beginning-search-forward  # alt + down
    bindkey "^[^[[D" backward-word         # alt + left
    bindkey "^[^[[C" forward-word          # alt + right
    bindkey "^[[d" beginning-of-line       # shift + left
    bindkey "^[[c" end-of-line         # shift + right

    # Make WSAD work in completion menus
    bindkey -M menuselect a backward-char
    bindkey -M menuselect s down-line-or-history
    bindkey -M menuselect d forward-char
    bindkey -M menuselect w up-line-or-history

    # shift-tab performs backwards menu completion
    if [[ -n "$terminfo[kcbt]" ]]; then
        bindkey "$terminfo[kcbt]" reverse-menu-complete
    elif [[ -n "$terminfo[cbt]" ]]; then # required for GNU screen
        bindkey "$terminfo[cbt]"  reverse-menu-complete
    fi

    if [[ -n ${(k)modules[zsh/complist]} ]] ; then
        #k# menu selection: pick item but stay in the menu
        bindkey -M menuselect '^K' accept-and-menu-complete

        # accept a completion and try to complete again by using menu
        # completion; very useful with completing directories
        # by using 'undo' one's got a simple file browser
        bindkey -M menuselect '^O' accept-and-infer-next-history
    fi

    slash-backward-kill-word() { # slash and space as seperator
        local WORDCHARS="${WORDCHARS:s@/@}"
        # zle backward-word
        zle backward-kill-word
    }
    zle -N slash-backward-kill-word
    bindkey "^[^?" slash-backward-kill-word    # alt + backspace

    insert_sudo() {
        case "$BUFFER" in
            sudo*) BUFFER=${BUFFER/sudo /};;
            *)     BUFFER="sudo $BUFFER"; CURSOR+=5;;
        esac
    }
    zle -N insert-sudo insert_sudo
    bindkey '^H' insert-sudo
    
    # Move to where the arguments belong.
    after-first-word() {
      zle beginning-of-line
      zle forward-word
    }
    zle -N after-first-word
    bindkey "^A" after-first-word

    insert-last-typed-word() { zle insert-last-word -- 0 -1; };
    zle -N insert-last-typed-word
    bindkey '^N' insert-last-typed-word

    # edit long command lines in $EDITOR
    autoload edit-command-line
    zle -N edit-command-line
    bindkey '^g'  edit-command-line

    #bindkey "^i" expand-or-complete-prefix      # completion in the middle of a word
    #bindkey "^b" menu-complete          # menu completion via esc-i
    #}}}

    xunfunction() {
        emulate -L zsh
        local -a funcs
        funcs=(xunfunction zrcautoload)

        for func in $funcs ; do [[ -n ${functions[$func]} ]] && unfunction $func; done
        return 0
    }

    hash -d sh="/mnt/share"
    hash -d box=~sh/Dropbox
    hash -d lin=~box/linux
    hash -d bin=~lin/bin
    hash -d fun=~lin/funpics
    hash -d code=~sh/code
    hash -d build=~code/build
    hash -d learn=~code/learn
    hash -d docs=~learn/docs
    hash -d git=~code/git
    hash -d s=~box/var
    hash -d aus=~s/ausbildung
    hash -d bew=~s/bewerbung
    hash -d boot="/boot"                    \
            etc="/etc"                      \
            mnt="/mnt"                      \
            smb="/mnt/smb"                  \
            srv="/srv"                      \
            t="/tmp"                        \
            usr="/usr"                      \
            var="/var"                      \
            med="/media"                    \
            conf="$HOME/.config"            \
            bak="$HOME/.backup"             \
            down="$HOME/down"               \
            wp="$HOME/.local/wallpapers"    \
            scr="$HOME/.local/screenshots"  \
            awe="$HOME/.config/awesome"     \
            awet="$HOME/.config/awesome/themes" \
            themes="$HOME/.themes"          \
            mpd="$HOME/.mpd"                \
            mpdpl="$HOME/.mpd/playlists"    \
            hd="/home/demian"               \
            hs="/home/slave"                \
            cache="/var/cache/pacman/pkg"   \
            log="/var/log"                  \
            logs="$HOME/.logs"              \
            http="/srv/http"
    # hash directories (call with b, ~b, cd b or cd ~b)
    if [[ $HOST = laptop ]];then
    hash -d ibm="/proc/acpi/ibm"                        \
            BAT="/sys/devices/platform/smapi/BAT0"      \
            bright="/sys/class/backlight/acpi_video0"   \
            acpi="/sys/devices/platform/thinkpad_acpi"  \
            m="/mnt/smb"                    \
            g="/mnt/smb/games"              \
            i="/mnt/smb/incoming"           \
            mov="/mnt/smb/mov"              \
            share="/mnt/smb/share"          \
            ser="/mnt/smb/ser"
    elif [[ $HOST = htpc ]];then
    hash -d m="/media"                      \
            g="/media/games"                \
            i="/media/incoming"             \
            mov="/media/mov"                \
            ser="/media/ser"                \
            mus=~sh/music                   \
            favs=~mus/favs
    fi

    ## CD
    DIRSTACKSIZE=${DIRSTACKSIZE:-20}
    DIRSTACKFILE=${DIRSTACKFILE:-${HOME}/.zdirs}

    if [[ -f ${DIRSTACKFILE} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
        dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
        # "cd -" won't work after login by just setting $OLDPWD, so
        [[ -d $dirstack[0] ]] && cd $dirstack[0] && cd $OLDPWD
    fi

    #rationalise-dot() { [[ $LBUFFER = *.. ]] && LBUFFER+=/.. || LBUFFER+=.; }
    #zle -N rationalise-dot
    #bindkey . rationalise-dot

    dirname-previous-word () {
        autoload -U modify-current-argument
        modify-current-argument '${ARG:h}'
    }
    zle -N dirname-previous-word
    bindkey '^K' dirname-previous-word

    setopt  AUTO_CD      \
            AUTO_PUSHD   \
            CHASE_LINKS  \
            PUSHD_MINUS  \
            PUSHD_SILENT \
            PUSHD_TO_HOME

    # Window titles will screw up tty so only set them for X
    if [[ $_isxrunning = true ]];then
        precmd() {
            #rehash
            print -Pn "\e]2;$0 (%~) %n@%m\a"
        }
        preexec() {
            LS_USED=$(echo $1|cut -d' ' -f1)
            print -Pn "\e]2;$1 (%~) %n@%m\a"
        }
    fi

    chpwd() {
        case $LS_USED in
            cd)     ls --color=auto --group-directories-first -hF;;
            cdl)     ls --color=auto --group-directories-first -hlF;;
            cda)     ls --color=auto --group-directories-first -hlAF;;
            *) ls --color=auto --group-directories-first -hF;;
        esac
    }
    alias {cda,cdl,cdd,cdf,cdad,cdaf,cdbig,cdnew,cdold,cdsmall}="cd"
    alias b="popd"

    countdown() {
        local seconds="$1"
        local secs
        if [[ "$seconds" =~ ^[0-9]+[Ss]?$ ]];then
            # count down
            seconds=${seconds/%?/}
            secs=$(( $seconds - 1 ))
            while [[ "$secs" -ge 0 ]];do
                [[ "$die" == yes ]] && return 0
                sleep 1 &>/dev/null
                printf "\rcounting (%02d/$seconds)" $((secs))
                secs=$(( $secs - 1 ))
                wait
            done
        elif [[ "$seconds" =~ ^[0-9]+[Mm]$ ]];then
            seconds=$(( ${seconds/%?/} * 60 ))
            secs=$(( $seconds - 1 ))
            while [[ "$secs" -ge 0 ]];do
                [[ "$die" == yes ]] && return 0
                sleep 1 &>/dev/null
                printf "\rcounting (%02d/$seconds)" $((secs))
                secs=$(( $secs - 1 ))
                wait
            done
        elif [[ "$seconds" =~ ^[0-9]+[Hh]$ ]];then
            seconds=$(( ${seconds/%?/} * 3600 ))
            secs=$(( $seconds - 1 ))
            while [[ "$secs" -ge 0 ]];do
                [[ "$die" == yes ]] && return 0
                sleep 1 &>/dev/null
                printf "\rcounting (%02d/$seconds)" $((secs))
                secs=$(( $secs - 1 ))
                wait
            done
        else
            # count up
            secs=1
            while true;do
                [[ "$die" == yes ]] && return 0
                sleep 1 &>/dev/null
                printf "\rcounting ($secs)"
                secs=$(( $secs + 1 ))
                wait
            done
        fi
        echo
    }

    smart_sudo()  {
        integer glob=1
        local -a run
        run=( command sudo )
        if [[ $# -gt 1 && $1 = -u ]]; then
            run+=($1 $2)
            shift ; shift
        fi
        (($# == 0)) && 1=/bin/zsh
        while (($#)); do
            case "$1" in
            command|exec|-) shift; break ;;
            nocorrect) shift ;;
            noglob) glob=0; shift ;;
            *) break ;;
            esac
        done
        if ((glob)); then
            PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $~==*
        else
            PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH" $run $==*
        fi
    }
    alias sudo="noglob smart_sudo "
    alias s="sudo"
    compdef _sudo smart_sudo

    ## aliases and functions
    alias mmv="noglob zmv -W"
    alias mv="nocorrect mv"
    alias rm="nocorrect rm"
    alias cp="nocorrect cp"
    alias ls0="ls **/*(ND.L0m+0m-2) **/*.bak"
    alias rm0="rm -i *(.L0) *.bak(.)"

    # edit
    alias vnew="vim *(.om[1])"         # edit newest file
    alias vnew3="vim -p *(.om[1,3])"   # open 3 newest files in tabs
    alias vtoday="vim -p *(m0)"            # re-edit all files changed today!
    if [[ $_isxrunning = true ]];then
        alias mnew="m *(.om[1])"         # edit newest file
        alias mnew3="m *(.om[1,3])"      # open 3 newest files in tabs
        alias mtoday="m *(m0)"           # re-edit all files changed today!
    fi

    # ls hidden
    alias lh="ls -d .*"            # list hidden files/directories
    alias llh="ls -lhd .*"         # list details of hidden files/directories
    alias llhd="ls -lhd .*(-/N)"       # list details of hidden directories
    alias llhf="ls -lh .*(-.N)"        # list details of hidden files

    # ls directories
    alias lsd="ls -d *(-/N)"        # list visible directories
    alias lhd="ls -d .*(-/N)"      # list hidden directories
    alias lad="ls -d *(-/DN)"      # list all directories
    alias lld="ll -d *(-/N)"       # list details of visible directories
    alias llad="ls -lhd *(-/DN)"       # list details of all directories

    # ls files
    alias lf="ls *(-.N)"           # list visible files
    alias lhf="ls .*(-.N)"         # list hidden files
    alias laf="ls -A *(-.DN)"      # list all files
    alias llf="ll *(-.N)"          # list details of visible files
    alias llaf="ls -lhA *(-.DN)"       # list details of all files

    # ls empty
    alias len="ls -ld **/*(/^F)"
    alias le="ls -d *(-/DN^F)"         # list all empty directories
    alias ler="ls -d **/*(-/DN^F)"     # list all empty directories recursively
    alias lefr="ls -d **/*(-/N^F)"     # list all empty directories recursively
    alias lle="ls -ld *(-/DN^F)"       # list details of all empty directories
    alias ller="ls -lhd **/*(-/DN^F)"  # list details of all empty directories recursively

    # ls various
    alias dud="du -hs *(/)"        # show directory sizes
    alias lsx="ls -l *(*)"         # only executables
    alias lsw="ls -ld *(R,W,X.^ND/)"   # world-{readable,writable,executable} files
    alias ls2m="ls -l *(Lm+2) 2>/dev/null" # list files bigger than 2 megabytes
    alias lnx="ls *~*.*(.)"        # list files without extension
    alias lpics="ls *.(jpg|jpeg|gif) N2"

    mmvlc() { [[ $1 = -r ]] && zmv '(**/)(*)' '$1${(L)2}' || zmv '(*)' '${(L)1}'; }
    mmvsp() { [[ $1 = -r ]] && zmv '(**/)(* *)' '$f:gs/ /_' || zmv '(* *)' '$f:gs/ /_'; }
    alias mmvboth="mmvsp ; mmvlc"
    alias mmvrboth="mmvspr ; mmvlcr"
    mmvspecial() { # remove  / : ; * = " ' ( ) < > | from filenames
        unwanted="[(:);*?\"<>|']"
        zmv -Q "(**/)(*$~unwanted*)(D)" '$1${2//$~unwanted/}'
    }
    alias mmvrall="mmvspecial && mmvrboth"
    ## correction and completion
    CORRECT_IGNORE="_*"
    setopt  NO_ALWAYS_TO_END    \
            BRACE_CCL        \
            COMPLETE_IN_WORD \
            GLOB_COMPLETE    \
            NO_AUTO_LIST        \
            MENU_COMPLETE    \
            LIST_PACKED      \
            LIST_TYPES       \
            NO_SH_WORD_SPLIT    \
            NO_NOMATCH

    #          CORRECT_ALL      \

    ## zstyle
    # options
    zstyle ':completion:*:match:*'        original only
    zstyle ':completion::prefix-1:*'      completer _complete
    zstyle ':completion:predict:*'        completer _complete
    zstyle ':completion:incremental:*'        completer _complete _correct
    zstyle ':completion:*'            completer _complete _prefix _correct _prefix _match _approximate
    # allow one error for every three characters typed in approximate completer
    #zstyle ':completion:*:approximate:'      max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )'
    # tab, don't annoy me!
    zstyle ':completion:*'            insert-tab pending
    # menu
    zstyle ':completion:*'            menu select=1
    zstyle ':completion:*'            select-prompt '%SScrolling active: current selection at %p%s.'
    #zstyle ':completion:*'           list-prompt '%SAt %p: Hit TAB for more or BACKSPACE to get out.%s'
    # colors
    zstyle ':completion:*'            list-colors ${(s.:.)LS_COLORS}
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
    # caching
    zstyle ':completion::complete:*'      use-cache on
    zstyle ':completion::complete:*'      cache-path ~/.cache/zsh
    # ignore commands i dont _have
    zstyle ':completion:*:functions'      ignored-patterns '_*'
    # dont complete backups as executables
    zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
    # path expansion
    zstyle ':completion:*'            expand 'yes'
    zstyle ':completion:*'            squeeze-slashes 'yes'
    zstyle ':completion::complete:*'      '\\'
    # allow forced showing'
    zstyle '*'                    single-ignored show
    # case insensitivity, partial matching, substitution
    zstyle ':completion:*'            matcher-list 'm:{a-z}={A-Z}' 'm:{A-Z}={a-z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
    # group matches and describe
    zstyle ':completion:*:matches'        group 'yes'
    zstyle ':completion:*'            group-name ''
    zstyle ':completion:*:options'        description 'yes'
    zstyle ':completion:*:options'        auto-description '%d'
    zstyle ':completion:*:descriptions'       format $'\e[01;33m -- %d --\e[0m'
    zstyle ':completion:*:messages'       format $'\e[01;35m -- %d --\e[0m'
    zstyle ':completion:*:warnings'       format $'\e[01;31m -- No Matches Found --\e[0m'
    # prevent re-suggestion
    zstyle ':completion:*:(rm|kill|diff):*'   ignore-line yes
    #zstyle ':completion:*:(scp|cp|mv|ls):*'  ignore-line yes
    zstyle ':completion:*:(cd|mv|cp):*'       ignore-parents parent pwd
    # menu for kill
    zstyle ':completion:*:*:kill:*'       menu yes select
    zstyle ':completion:*:kill:*'         force-list always
    # kill menu extension!
    zstyle ':completion:*:processes'      command 'ps -U $(whoami) | sed "/ps/d"'
    zstyle ':completion:*:processes'      insert-ids menu yes select
    # complete 'cd -<tab>' with menu
    zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
    zstyle ':completion:*:*:cd:*'         tag-order local-directories path-directories
    # provide more processes in completion of programs like killall
    zstyle ':completion:*:processes-names'    command 'ps c -u ${USER} -o command | uniq'
    # offer indexes before parameters in subscripts
    zstyle ':completion:*:*:-subscript-:*'    tag-order indexes parameters
    # insert all expansions for expand completer
    zstyle ':completion:*:expand:*'       tag-order all-expansions
    # ignore completion functions for commands you don't _have
    zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
    # history
    zstyle ':completion:*:history-words'      list false
    zstyle ':completion:*:history-words'      menu yes                 # activate menu
    zstyle ':completion:*:history-words'      remove-all-dups yes      # ignore duplicate entries
    zstyle ':completion:*:history-words'      stop yes
    # provide '..' as a completion
    zstyle ':completion:*'            special-dirs ..
    # complete manual by their section
    zstyle ':completion:*:manuals'        separate-sections true
    #zstyle ':completion:*:manuals.*'     insert-sections true
    zstyle ':completion:*:man:*'          menu yes select
    # CVS
    zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
    zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
    # ignore lost and found
    zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'
    # remove uninteresting users
    zstyle ':completion:*:*:*:users'      ignored-patterns                        \
                        adm alias apache at backup  bind bin cron cyrus daemon  \
                        dictd ftp games gdm gnats guest  haldaemon halt ident   \
                        identd irc junkbust mail mailnull man messagebus mysql  \
                        named news nobody nut nfsnobody nscd ntp lp operator    \
                        portage postfix postgres postmaster proxy qmaild qmaill \
                        pcap qmailp qmailq qmailr qmails radvd rpc rpcuser rpm  \
                        shutdown smmsp squid sshd sync sys uucp vcsa vpopmail   \
                        www-data xfs
    # remove uninteresting hosts
    zstyle ':completion:*:*:*:hosts-host'     ignored-patterns    \
                        '*.*' loopback localhost
    zstyle ':completion:*:*:*:hosts-domain'   ignored-patterns  \
                        '<->.<->.<->.<->' '^*.*' '*@*'
    zstyle ':completion:*:*:*:hosts-ipaddr'   ignored-patterns  \
                        '^<->.<->.<->.<->' '127.0.0.<->'
    zstyle ':completion:*:(ssh|scp):*'        hosts htpc
    # ssh completion
    zstyle ':completion:*:scp:*'          tag-order   \
                        files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
    zstyle ':completion:*:scp:*'          group-order \
                        files all-files users hosts-domain hosts-host hosts-ipaddr
    zstyle ':completion:*:ssh:*'          tag-order   \
                        users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
    zstyle ':completion:*:ssh:*'          group-order \
                        hosts-domain hosts-host users hosts-ipaddr

    zstyle ':completion:*' hosts router htpc mex felix-pc laptop kristin-pc ap ipod

    ## compctl
    # make completion
    compile=(all clean compile disclean install remove uninstall)
    compctl -k compile make

  
    # hosts completion for a few commands
    compctl -k hosts ftp lftp ncftp ssh w3m lynx links elinks nc telnet rlogin host
    compctl -k hosts -P '@' finger

    # complete only dirs (or symlinks to dirs in some cases) for certain commands
    compctl -g '*(/)' rmdir dircmp
    compctl -g '*(-/)' cd chdir dirs pushd

    # command file type detection
    compctl -g '*.tar.gz *.tgz *.tar.bz2 *.bz2 *.tar *.tbz2 *.tbz *.gz *.rar *.zip *.7z *.lzo *.xz *.txz *.lzma *.tlz *.Z' + -g '*(-/)' atool apack aunpack ad al
    compctl -g '*.(gz|z|Z|t[agp]z|tarZ|tz)' + -g '*(-/)' gunzip gzcat zcat
    compctl -g '*.pkg.tar.gz *.pkg.tar.xz' + -g '*' pu
    compctl -g '*.ebuild' ebuild
    compctl -g '*.(pdf|PDF)' + -g '*(-/)' evince epdfview apvlv
    compctl -g '[^.]*(-/) *.(c|C|cc|c++|cxx|cpp)' + -f cc CC c++ gcc g++
    compctl -g '[^.]*(-/) *(*)' + -f strip ldd gdb
    compctl -g '*.(jpg|JPG|jpeg|JPEG|gif|GIF|png|PNG|bmp)' + -g '*(-/)' eog mirage viewnior gimp feh gpicview
    compctl -g '*.(e|E|)(ps|PS)' + -g '*(-/)' gs ghostview nup psps pstops psmulti psnup psselect gv
    compctl -g '*.tex*' + -g '*(-/)' {,la,gla,ams{la,},{g,}sli}tex texi2dvi
    compctl -g '*.dvi' + -g '*(-/)' dvipdf dvipdfm
    compctl -g '*.java' + -g '*(-/)' javac
    compctl -g '*.py' python
    compctl -g '*.dvi' + -g '*(-/)' dvips
    compctl -g '*(-/)' + -g '.*(/)' cd chdir dirs pushd rmdir dircmp cl tree
    compctl -g "*.html *.htm" + -g "*(-/) .*(-/)" + -H 0 '' firefox w3m lynx links wget opera
    compdef _pacman {pacman-color,clyde,powerpill,bauerbill}=pacman

    # command parameter completion
    compctl -z fg
    compctl -j kill
    compctl -j disown
    compctl -u chown
    compctl -u su
    compctl -c sudo
    compctl -c which
    compctl -c type
    compctl -c hash
    compctl -c unhash
    compctl -o setopt
    compctl -o unsetopt
    compctl -a alias
    compctl -a unalias
    compctl -A shift
    compctl -v export
    compctl -v unset
    compctl -v echo
    compctl -b bindkey

    # completion for some builtins
    compctl -z -P '%' bg
    compctl -j -P '%' fg jobs disown
    compctl -j -P '%' + -s '`ps -x | tail +2 | cut -c1-5`' wait
    compctl -A shift
    compctl -c type whence where which
    compctl -m -x 'W[1,-*d*]' -n - 'W[1,-*a*]' -a - 'W[1,-*f*]' -F -- unhash
    compctl -m -q -S '=' -x 'W[1,-*d*] n[1,=]' -g '*(-/)' - 'W[1,-*d*]' -n -q -S '=' - 'n[1,=]' -g '*(*)' -- hash
    compctl -F functions unfunction
    compctl -k '(al dc dl do le up al bl cd ce cl cr dc dl do ho is le ma nd nl se so up)' echotc
    compctl -a unalias
    compctl -v getln getopts read unset vared
    compctl -v -S '=' -q declare export integer local readonly typeset
    compctl -eB -x 'p[1] s[-]' -k '(a f m r)' - 'C[1,-*a*]' -ea - 'C[1,-*f*]' -eF - 'C[-1,-*r*]' -ew -- disable
    compctl -dB -x 'p[1] s[-]' -k '(a f m r)' - 'C[1,-*a*]' -da - 'C[1,-*f*]' -dF - 'C[-1,-*r*]' -dw -- enable
    compctl -k "(${(j: :)${(f)$(limit)}%% *})" limit unlimit
    compctl -l '' -x 'p[1]' -f -- . source
    compctl -s '$(setopt 2>/dev/null)' + -o + -x 's[no]' -o -- unsetopt
    compctl -s '$(unsetopt)' + -o + -x 's[no]' -o -- setopt
    compctl -s '${^fpath}/*(N:t)' autoload
    compctl -b bindkey
    compctl -c -x 'C[-1,-*k]' -A - 'C[-1,-*K]' -F -- compctl
    compctl -x 'C[-1,-*e]' -c - 'C[-1,-[ARWI]##]' -f -- fc
    compctl -x 'p[1]' - 'p[2,-1]' -l '' -- sched
    compctl -x 'C[-1,[+-]o]' -o - 'c[-1,-A]' -A -- set

    # PROMPT
    prompt_small() {          
        h1=${HOST:0:1}
        if [[ $HOST == laptop ]];then
            PROMPT="%{$fg[red]%}%(?. .%?)%{$reset_color%}%{$fg[blue]%}>> %{$reset_color%}"
            [[ $EUID = 0 ]] && PROMPT="%{$fg[red]%}%(?. .%?)%{$reset_color%}%{$fg[red]%}# %{$reset_color%}"
        else
            PROMPT="%{$fg[red]%}%(?. .%?)%{$reset_color%}%{$fg[green]%}$h1$h1 %{$reset_color%}"
            [[ $EUID = 0 ]] && PROMPT="%{$fg[red]%}%(?. .%?)%{$reset_color%}%{$fg[green]%}$h1%{$reset_color%}%{$fg[red]%}# %{$reset_color%}"
        fi
        source ~/.zsh/zsh-git-prompt/zshrc.sh
        #RPROMPT="%b$(git_super_status)%# [%~] %*"
        RPROMPT='%b$(git_super_status) [%~] %* '
    }

    prompt_big() {
        # Options for ZSH
        autoload -U promptinit && promptinit


        function precmd {
            local TERMWIDTH
            (( TERMWIDTH = ${COLUMNS} - 1 ))

            PR_FILLBAR=""
            PR_PWDLEN=""

            local promptsize=${#${(%):---(%n@%m:%l)---()--}}
            local pwdsize=${#${(%):-%~}}

            if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
                ((PR_PWDLEN=$TERMWIDTH - $promptsize))
            else
                PR_FILLBAR="\${(l.(($TERMWIDTH - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
            fi
        }


        setopt extended_glob
        preexec () {
            if [[ "$TERM" == "screen" ]]; then
                local CMD=${1[(wr)^(*=*|sudo|-*)]}
                echo -n "\ek$CMD\e\\"
            fi
        }


        setprompt () {
            ###
            # Need this so the prompt will work.
            setopt prompt_subst

            ###
            # See if we can use colors.
            autoload colors zsh/terminfo
            if [[ "$terminfo[colors]" -ge 8 ]]; then
                colors
            fi
            for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
                eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
                eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
                (( count = $count + 1 ))
            done
            PR_NO_COLOUR="%{$terminfo[sgr0]%}"

            ###
            # See if we can use extended characters to look nicer.
            typeset -A altchar
            set -A altchar ${(s..)terminfo[acsc]}
            PR_SET_CHARSET="%{$terminfo[enacs]%}"
            PR_SHIFT_IN="%{$terminfo[smacs]%}"
            PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
            PR_HBAR=${altchar[q]:--}
            PR_ULCORNER=${altchar[l]:--}
            PR_LLCORNER=${altchar[m]:--}
            PR_LRCORNER=${altchar[j]:--}
            PR_URCORNER=${altchar[k]:--}

            ###
            # Decide if we need to set titlebar text.
            case $TERM in
                xterm*)
                    PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m: (%~)x | ${COLUMNS}x${LINES} | %y\a%}'
                    ;;
                screen*)
                    PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m: (%~) | ${COLUMNS}x${LINES} | %y\e\\%}'
                    ;;
                *)
                    PR_TITLEBAR=''
                    ;;
            esac

            ###
            # Finally, the prompt.
            PROMPT='$PR_SET_CHARSET${(e)PR_TITLEBAR}\
$PR_SHIFT_IN$PR_ULCORNER$PR_HBAR$PR_SHIFT_OUT(\
%(!.$PR_RED%SROOT%s$PR_NO_COLOUR.%n)@%m\
)$PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_HBAR$PR_SHIFT_OUT(\
%$PR_PWDLEN<...<%~%<<\
)$PR_SHIFT_IN$PR_HBAR$PR_URCORNER$PR_SHIFT_OUT\

$PR_SHIFT_IN$PR_LLCORNER$PR_HBAR$PR_SHIFT_OUT(\
%(?..%?$:)\
%D{%H:%M}\
%(!..))$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

        RPROMPT=' $PR_SHIFT_IN$PR_HBAR$PR_HBAR$PR_SHIFT_OUT\
(%D{%a,%b%d})$PR_SHIFT_IN$PR_HBAR$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

        PS2='$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
%_)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
            }

        setprompt
    }
    
    alias pphil="source $HOME/.philsprompt"
    #[[ -f $HOME/.dircolors ]] && eval $(/bin/dircolors -b $HOME/.dircolors) || LS_COLORS="no=00:fi=00:rs=0:di=04:ex=00:" && export LS_COLORS
    alias lscolor='eval `dircolors -b $HOME/.dircolors`'
    # actual prompt
    promptis=
    if [[ $promptis = big ]]; then
        prompt_big
    else
        prompt_small
    fi
fi
#}}}

alias sysupgrade="sudo pacman -Syw && sudo snp pacman -Su"

# Enable SSH-Agent
if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
    ssh-add $HOME/.ssh/git
    ssh-add $HOME/.ssh/home
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'

tpspeed() {
    local speed=${1:-0.4}
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
    xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" $speed
    echo $speed
}

sysbackup() {
	# archive, keep attributes, keep extended attributes, verbose, delete obsolete destination files
	rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/home/*/.thumbnails","/home/*/.cache/spotify","/home/*/.cache/mozilla","/home/*/.cache/chromium","/home/*/.local/share/Trash/*","/home/*/.gvfs","/.snapshots"} / /media/backup
}

system_state() {
	systemctl --failed
	journalctl -p 0..3 -xn
}
