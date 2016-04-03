#!/usr/bin/env bash
# Based on https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/archlinux/archlinux.plugin.zsh

cmds=( yaourt pacupg pacaur abs aur )
for cmd in "${cmds[@]}"; do
    have "${cmd}" && export "_have_${cmd}"=1
done

# {{{ Pacman
alias pac="pacman"
alias pacin="${_SUDO} pacman -S"    # Install specific package(s) from the repositories
alias pacind="${_SUDO} pacman -S --asdeps" # Install given package(s) as dependencies of another package
alias pacinf="${_SUDO} pacman -U"   # Install specific package not from the repositories but from a file
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
alias pacupd="${_SUDO} pacman -Sy"                 # Update and refresh the local package database against repositories
[[ "${_have_abs}" ]] && alias pacupd="${_SUDO} pacman -Sy && ${_SUDO} abs"
[[ "${_have_pacupg}" ]] && alias pacupg="${_SUDO} pacman -Syu" # Synchronize with repositories before upgrading packages that are out of date on the local system.

# https://bbs.archlinux.org/viewtopic.php?id=93683
paclist() {
    LC_ALL=C pacman -Qei $(pacman -Qu | cut -d"" -f 1) | awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

pacdisowned() {
    local tmpdir=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
    local db="${tmpdir}/db"
    local fs="${tmpdir}/fs"

    mkdir "${tmpdir}"
    trap ' rm-rf"${tmpdir}" ' EXIT

    pacman -Qlq | sort -u > "${db}"

    find /bin /etc /lib /sbin /usr  \
 ! -name lost+found  \
 \( -type d -printf '%p/\n' -o -print \) | sort > "${fs}"

    comm -23 "${fs}" "${db}"
}

pacgetkeys() { # Get all keys for developers and trusted users
    curl https://www.archlinux.org/people/{developers,trusted-users}/ |
    awk -F\" '(/pgp.mit.edu/) {sub(/.*search=0x/,"");print $1}'
}

pacimportkeys() {
    pacgetkeys | xargs ${_SUDO} pacman-key --recv-keys
}

pacsignkeys() {
    for key in $*; do
        ${_SUDO} pacman-key --recv-keys "${key}"
        ${_SUDO} pacman-key --lsign-key "${key}"
        printf 'trust\n3\n' | ${_SUDO} gpg --homedir "/etc/pacman.d/gnupg"  \
 --no-permission-warning --command-fd 0 --edit-key "${key}"
    done
}
# }}}


# {{{ Yaourt/AUR Helper
if [[ "${_have_yaourt}" ]]; then
    alias ya="yaourt"
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
    alias yaupd="yaourt -Sy"    # Update and refresh the local package database against repositories
    [[ "${_have_aur}" ]] && alias yaupd="yaourt -Sy && ${_SUDO} aur"
    alias yaupg="${_SUDO} yaourt -Syua" # Synchronize with repositories before upgrading packages (AUR packages too) that are out of date on the local system.
    [[ "${_have_pacupg}" ]] && alias yaupg="pacupg -a"
fi
# }}}

# {{{ Pacaur
if [[ "${_have_pacaur}" ]]; then
    alias pa="pacaur"
    alias pain="pacaur -S"      # Install specific package(s) from the repositories
    alias painf="pacaur -U"     # Install specific package not from the repositories but from a file
    alias pare="pacaur -R"      # Remove the specified package(s), retaining its configuration(s) and required dependencies
    alias parem="pacaur -Rns"   # Remove the specified package(s), its configuration(s) and unneeded dependencies
    alias parep="pacaur -Si"    # Display information about a given package in the repositories
    alias pareps="pacaur -Ss"   # Search for package(s) in the repositories
    alias paloc="pacaur -Qi"    # Display information about a given package in the local database
    alias palocs="pacaur -Qs"   # Search for package(s) in the local database
    alias palst="pacaur -Qe"    # List installed packages, even those installed from AUR (they"re tagged as "local")
    alias paorph="pacaur -Qtd"  # Remove orphans using pacaur
    alias painsd="pacaur -S --asdeps" # Install given package(s) as dependencies of another package
    alias pamir="pacaur -Syy"   # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
    alias paupd="pacaur -Sy"    # Update and refresh the local package database against repositories
    [[ "${_have_aur}" ]] && alias paupd="pacaur -Sy && ${_SUDO} aur"
    alias paupg="${_SUDO} pacaur -Syua" # Synchronize with repositories before upgrading packages (AUR packages too) that are out of date on the local system.
    [[ "${_have_pacupg}" ]] && alias paupg="pacupg -a"
fi
# }}}

# {{{ Makepkg/Building
# Update PKGBUILD with new checksums and create/update .SRCINFO file for AUR.
alias makepkgs="updpkgsums && mksrcinfo"
# }}}