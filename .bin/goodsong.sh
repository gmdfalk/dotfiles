#!/bin/bash
#
# goodsong: maintain a list of favourite songs.
#
# pbrisbin 2009, 2010
#
# Contributors:
#   Tom Vincent <http://www.tlvince.com/contact/>
#   Christian
#
###

errorout() { echo "$*" >&2; exit 1; }

message() {
  cat << EOF
usage: goodsong [option]

  options:

        -p, --play        play a random song from list, now

        -b, --build       build a playlist from your list, play it

        -s, --show        display a random song from list

        -f, --find regex  find a song in your list using grep 'regex'

        -S, --smart       select a song from your list; find it in
                          your current playlist or add it; when the
                          current song ends, play it

        -P, --print       print your list with music dir prepended

        -h, --help        display this

        none              append playing song to list

EOF
}

# Return the mpd.conf passed as a parameter to mpd or an expected default
locateMPDConf() {
  # Don't use any command that overrides the "real" mpd binary
  local config='/home/demian/.mpd/mpd.conf'
}

# From the given property key ($1), lookup the value in the given ini file ($2),
# where value can be single, double, or un-quoted.
confParser() {
    sed -r '/^'"$1"' *(\"|'\''|)([^\1]*)\1/!d; s//\2/g' "$2"
}

# From the given regex ($1), find the relevant mpd.conf property value
mpdParam() {
  local param="$(confParser "$1" "$(locateMPDConf)")"
  [[ -z $param ]] && errorout "'$1' is an invalid mpd.conf property key"
  echo "${param/\~/$HOME}"   # translate '~' to '$HOME'
}

# just prints your list with the music dir prepended (for easy piping, etc)
printlist() {
  local mdir="$(mpdParam '^music_directory')"
  sed "s|^|$mdir/|g" "$list"
}

# return playlist position of a random good song
get_pos() {
  local track="$(cat $list | sort -R | head -n 1)" pos

  pos=$(mpc --format '%position% %file%' playlist | \
        awk "/[0-9]* ${track//\//\\/}$/"'{print $1}' | head -n 1)

  if [[ -z "$pos" ]]; then
    mpc add "$track"
    pos=$(mpc playlist | wc -l)
  fi

  echo "$pos"
}

# returns current seconds remaining
get_lag() {
  local time curm curs totm tots lag N

  time="$(mpc | awk '/playing/ {print $3}')"

  if [[ -n "$time" ]]; then
    while IFS=':' read -r curm curs totm tots; do
      cur=$((curm*60+curs))
      tot=$((totm*60+tots))

      lag=$((tot-cur))
    done <<< "${time////:}"

    # adjust lag based on crossfade
    N=$(mpc crossfade | awk '{print $2}')
    [[ -n "$N" ]] && lag=$((lag-N))

    echo "$lag"
  else
    echo "0"
  fi
}

# build a playlist and play it
build_playlist() { mpc load goodsongs; mpc play; }

# add current song to the list
add_to_list() {
  # is mpd playing?
  mpc | grep -Fq playing || exit 1

  # get song filename
  song="$(mpc --format %file% | head -n 1)"

  # add it -- prevent dupes
  grep -Fqx "$song" "$list" || echo "$song" >> "$list"
}

# queue up a good song for when the current song ends
smart_play() { (sleep $(get_lag) && mpc play $(get_pos) &>/dev/null) & }

# show one random good song
show_one() { shuf -n1 "$list"; }

# play a random good song
play_one() { mpc play $(get_pos); }

# search the list
search_list() { grep -i "$*" "$list"; }

parse_options() {
  case "$1" in
    -h|--help)  message && exit 1       ;;
    -s|--show)  show_one                ;;
    -f|--find)  shift; search_list "$*" ;;
    -p|--play)  play_one                ;;
    -b|--build) build_playlist          ;;
    -S|--smart) smart_play              ;;
    -P|--print) printlist               ;;
    *)          add_to_list             ;;
  esac
}

list=/home/demian/.mpd/playlists/goodsongs.m3u
[[ -f "$list" ]] || touch "$list" 

parse_options "$@"

# vim: set ts=2 sw=2 :
