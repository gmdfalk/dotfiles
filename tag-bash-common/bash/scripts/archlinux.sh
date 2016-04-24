#!/usr/bin/env bash
# Based on https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/archlinux/archlinux.plugin.zsh

cmds=("yaourt" "pacupg" "pacaur" "abs" "aur" "expac")
for cmd in "${cmds[@]}"; do
    have "${cmd}" && export "_have_${cmd}"=1
done

# {{{ Pacman
alias cdpkg="cd /var/cache/pacman/pkg"
alias pac="pacman"
pacget() { ${_SUDO} abs && cd "$(find /var/abs -type d -iname "$@")"; } # Update abs and cd to PKGBUILD of a package.
alias pacin="${_SUDO} pacman -S"    # Install specific package(s) from the repositories
alias pacind="${_SUDO} pacman -S --asdeps" # Install given package(s) as dependencies of another package
alias pacins="${_SUDO} pacman -U"   # Install specific package not from the repositories but from a file
alias pacre="${_SUDO} pacman -R"    # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem="${_SUDO} pacman -Rns" # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep="pacman -Si"           # Display information about a given package in the repositories
alias pacreps="pacman -Ss"          # Search for package(s) in the repositories
alias pacown="pacman -Qo"           # Find owner of a package.
alias pacls="pacman -Ql"            # List all files owned by a package.
alias pacloc="pacman -Qi"           # Display information about a given package in the local database
alias paclocs="pacman -Qs"          # Search for package(s) in the local database
alias pacmir="${_SUDO} pacman -Syy" # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
alias paclsorphans="${_SUDO} pacman -Qdt"
alias pacrmorphans="${_SUDO} pacman -Rs $(pacman -Qtdq)"
alias pacupd="${_SUDO} pacman -Syu" # Update and refresh the local package database against repositories
[[ "${_have_abs}" ]] && alias pacupd="${_SUDO} pacman -Syu && ${_SUDO} abs"
paccheck() { [[ "$#" == 0 ]] && pacman -Qk | grep -v "0 missing" || pacman -Qk "$@"; }
# }}}

# {{{ Yaourt/AUR Helper
if [[ "${_have_yaourt}" ]]; then
    alias ya="yaourt"
    alias yaget="yaourt -G"     # Get PKGBUILD of package.
    alias yaconf="yaourt -C"    # Fix all configuration files with vimdiff
    alias yasu="yaourt --sucre" # Same as yaourt -Syua, but without confirmation
    alias yain="yaourt -S"      # Install specific package(s) from the repositories
    alias yains="yaourt -U"     # Install specific package not from the repositories but from a file
    alias yare="yaourt -R"      # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias yarem="yaourt -Rns"   # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias yarep="yaourt -Si"    # Display information about a given package in the repositories
    alias yareps="yaourt -Ss"   # Search for package(s) in the repositories
    alias yaloc="yaourt -Qi"    # Display information about a given package in the local database
    alias yalocs="yaourt -Qs"   # Search for package(s) in the local database
    alias yalst="yaourt -Qe"    # List installed packages, even those installed from AUR (they"re tagged as "local")
    alias yaorph="yaourt -Qtd"  # Remove orphans using yaourt
    alias yainsd="yaourt -S --asdeps" # Install given package(s) as dependencies of another package
    alias yamir="yaourt -Syy"   # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias yaupd="yaourt -Syua"   # Update and refresh the local package database against repositories
    [[ "${_have_aur}" ]] && alias yaupd="yaourt -Syua && ${_SUDO} aur"
    [[ "${_have_pacupg}" ]] && alias yaupg="pacupg -a"
fi
# }}}

# {{{ Pacaur
if [[ "${_have_pacaur}" ]]; then
    alias cdaur="cd ${XDG_CACHE_HOME:-${HOME}/.cache}/pacaur"
    alias pa="pacaur"
    alias paget="pacaur -d"     # Get PKGBUILD of package.
    alias pain="pacaur -S"      # Install specific package(s) from the repositories
    alias pains="pacaur -U"     # Install specific package not from the repositories but from a file
    alias pare="pacaur -R"      # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias parem="pacaur -Rns"   # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias parep="pacaur -Si"    # Display information about a given package in the repositories
    alias pareps="pacaur -Ss"   # Search for package(s) in the repositories
    alias paloc="pacaur -Qi"    # Display information about a given package in the local database
    alias palocs="pacaur -Qs"   # Search for package(s) in the local database
    alias palst="pacaur -Qe"    # List installed packages, even those installed from AUR (they"re tagged as "local")
    alias paorph="pacaur -Qtd"  # List orphans using pacaur
    alias painsd="pacaur -S --asdeps" # Install given package(s) as dependencies of another package
    alias pamir="pacaur -Syy"   # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias paupd="pacaur -Syua"  # Update and refresh the local package database against repositories
    [[ "${_have_aur}" ]] && alias paupd="pacaur -Syua && ${_SUDO} aur"
    [[ "${_have_pacupg}" ]] && alias paupg="pacupg -a"
fi
# }}}

# {{{ Expac
if [[ "${_have_expac}" ]]; then
    # Show sorted installation date of all installed packages.
    pacdate() { expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort --numeric-sort; }
    # Show sorted installation date of explicitly installed packages.
    pacexdate() { expac --timefmt='%Y-%m-%d %T' '%l\t%n' $(pacman -Qqe) | sort --numeric-sort; }
    # Show the installation size of all installed packages.
    pacsize() { expac --humansize M "%011m\t%n-%-20v" | sort --numeric-sort; }
    # Show the installation size of expliticly installed packages.
    pacexsize() { expac --humansize M "%011m\t%n-%-20v" $( comm -23 <(pacman -Qqe|sort) <(pacman -Qqg base base-devel|sort) ) | sort --numeric-sort; }
    # Show dependencies of packages.
    pacdep() { expac -l '\n' %E -S "$@" | sort --unique; }
fi
# }}}

# {{{ Makepkg/Building
# Update PKGBUILD with new checksums and create/update .SRCINFO file for AUR.
alias updpkg="updpkgsums && mksrcinfo"
alias cdabs="cd /var/abs"
# }}}