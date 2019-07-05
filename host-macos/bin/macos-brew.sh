#!/usr/bin/env bash

have() { command -v "$@" &>/dev/null; }

install_homebrew() {
    if ! have brew; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew update
    brew upgrade
}

# Compare https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
install_common_packages() {
    BREW_PREFIX=$(brew --prefix)

    # Custom
    brew cask install adoptopenjdk
    brew install dos2unix
    brew install ffmpeg
    brew install cloc
    brew install httpie
    brew install jq
    brew install ncdu
    brew install nginx
    brew install sloccount
    brew install telnet
    brew install tmux
    brew install wgetpaste
    brew install zsh
    brew install asdf
    brew install neovim
    brew install irssi

    # Install GNU core utilities (those that come with macOS are outdated).
    # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
    brew install coreutils \
      automake autoconf openssl \
      libyaml readline libxslt libtool unixodbc \
      unzip curl
    ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

    # Install some other useful utilities like `sponge`.
    brew install moreutils
    # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
    brew install findutils
    # Install GNU `sed`, overwriting the built-in `sed`.
    brew install gnu-sed --with-default-names
    # Install Bash 4.
    brew install bash
    brew install bash-completion2

    brew install wget

    # Install GnuPG to enable PGP-signing commits.
    brew install gnupg

    # Install more recent versions of some macOS tools.
    brew install vim --with-override-system-vi
    brew install grep
    brew install openssh
    brew install screen
    brew install php
    brew install gmp

    # Install font tools.
    brew tap bramstein/webfonttools
    brew install sfnt2woff
    brew install sfnt2woff-zopfli
    brew install woff2

    # Install some CTF tools; see https://github.com/ctfs/write-ups.
    brew install aircrack-ng
    brew install bfg
    brew install binutils
    brew install binwalk
    brew install cifer
    brew install dex2jar
    brew install dns2tcp
    brew install fcrackzip
    brew install foremost
    brew install hashpump
    brew install hydra
    brew install john
    brew install knock
    brew install netpbm
    brew install nmap
    brew install pngcheck
    brew install socat
    brew install sqlmap
    brew install tcpflow
    brew install tcpreplay
    brew install tcptrace
    brew install ucspi-tcp # `tcpserver` etc.
    brew install xpdf
    brew install xz

    # Install other useful binaries.
    brew install ack
    #brew install exiv2
    brew install git
    brew install git-lfs
    brew install imagemagick
    brew install lua
    brew install lynx
    brew install p7zip
    brew install pigz
    brew install pv
    brew install rename
    brew install rlwrap
    brew install ssh-copy-id
    brew install tree
    brew install vbindiff
    brew install zopfli

    # Switch to using brew-installed bash as default shell
    if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
      echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
      chsh -s "${BREW_PREFIX}/bin/zsh";
    fi;

    # Remove outdated versions from the cellar.
    brew cleanup
}

install_gui_packages() {
    brew cask install firefox
    brew cask install gimp
    brew cask install google-chrome
    brew cask install iterm2
    brew cask install jetbrains-toolbox
    brew cask install microsoft-teams
    #brew cask install onedrive
    brew cask install postman
    brew cask install sourcetree
    brew cask install the-unarchiver
}

install_backend_packages() {
    brew cask install adoptopenjdk
    brew install awscli
    brew install azure-cli
    brew install dnsmasq
    #brew install docker #  Better to install docker via Website
    brew install kubernetes-cli
    brew install kubernetes-helm
    brew install mongodb
    brew install postgresql
    brew install sonarqube
    brew install sqlite
    brew cask install minikube
    brew cask install ngrok
    brew cask install robo-3t
    brew cask install dbeaver-community
}

install_backend_version_manager() {
    if ! have sdk; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
        sdk install java 8.0.212.hs-adpt
        sdk install java 11.0.3.hs-adpt
    fi
}

install_frontend_packages() {
    brew install node
}

install_frontend_version_manager() {
    brew install nvm &&
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh" &&
    nvm install v8.16.0 &&
    nvm alias default v8.16.0
}

main() {
    install_homebrew || errorout "Homebrew could not be installed"
    install_common_packages
    install_gui_packages
    install_backend_packages
    install_backend_version_manager
    install_frontend_packages
    install_frontend_version_manager
}

main
