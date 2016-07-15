# dotfiles

Modular cross-platform multi-host configuration files for developers managed with [rcm](https://github.com/thoughtbot/rcm).

*This project is under development and probably won't leave alpha state before 2017*.

## Table of Contents

  * [About](#about)
  * [Quick intro to rcm](#quick-intro-to-rcm)
  * [Installation](#installation)
    * [On ArchLinux](#on-archlinux)
    * [On OSX](#on-osx)
    * [On Windows](#on-windows)
    * [Portable installation script](#portable-installation-script)
  * [Post-Install](#post-install)
    * [Configuration](#configuration)
      * [Git](#git)
    * [Customization](#customization)
    * [Maintenance](#maintenance)
    * [Startup Files](#startup-files)
  * [Features](#features)
    * [Solarized](#solarized)
    * [Vim](#vim)
    * [Tmux](#tmux)
    * [Awesome](#awesome)
    * [Shell](#shell)
        * [Fasd](#fasd)
        * [Common](#common)
        * [Bash](#bash)
        * [Zsh](#zsh)

## About

I use these dotfiles on all my machines running OSX, (Arch-)Linux and Windows 7/10 (currently with Cygwin64, hopefully soon replaced by [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux)).
It integrates some of the best and most popular frameworks for each component into a well-rounded and modular package tailored to developer needs.

If you

  * are a developer
  * like the command-line
  * like the vim/solarized combo and/or
  * need a cross-platform development environment

these dotfiles might be for you!

Features:
  * Combines some of the best frameworks for components like bash, zsh, vim, tmux etc.
  * Shared configuration (e.g. aliases) between bash and zsh (only bash available on the server? clone the dotfiles and use bash-it)
  * Portable between OSX, Linux and Windows
  * Vim-centric key bindings
  * Solarized colors, where possible

Frameworks/Libraries:
  * zsh: [prezto](https://github.com/sorin-ionescu/prezto)/[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  * bash: [bash-it](https://github.com/Bash-it/bash-it)
  * shell: [fasd](https://github.com/clvv/fasd)
  * vim: [spf13-vim](https://github.com/spf13/spf13-vim)
  * tmux: [tpm](https://github.com/tmux-plugins/tpm)
  * firefox: [pentadactyl](https://github.com/5digits/dactyl)/[vimperator](https://github.com/vimperator/vimperator-labs)

## Quick intro to rcm

rcm is a management suite for dotfiles. It works by creating symlinks from a source folder (e.g. this repository) to your $HOME directory based on the configuration you provide.
The default source path is ~/.dotfiles and ~/.rcrc for the configuration file.
Here are some of the commonly used commands:  

Status information:
* `lsrc` (lists all files managed by rcm)
* `lsrc -d ~/company_dotfiles` (specify a non-default directory)

Installing and deleting symlinks/tags:
* `rcup -v` (create/update all symlinks for ~/.rcrc or ~/.dotfiles/rcrc (and be verbose about it))
* `rcup -B mbpro` (create all symlinks for the host mbro (i.e. read ~/.dotfiles/host-mbpro/rcrc))
* `rcup -d ~/company_dotfiles` (install from a non-default dotfile directory)
* `rcup -t zsh -t vim` (only install the vim and zsh configurations)
* The same commands work with `rcdn` to unlink/deinstall tags or whole repositories.  

Adding and deleting files:
* `mkrc FILE` (add FILE to ~/.dotfiles/FILE)
* `mkrc -t TAG FILE` (will add FILE to ~/.dotfiles/tag-TAG)
* `mkrc -U -o FILE` (will add FILE to ~/.dotfiles/host-$HOSTNAME and install it without a leading dot)

## Installation

### On ArchLinux

```bash
    cd $HOME &&
    git clone https://aur.archlinux.org/rcm-git.git && cd rcm-git && makepkg -i &&
    git clone --recursive https://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### On Ubuntu

```bash
    cd $HOME &&
    sudo add-apt-repository ppa:martin-frost/thoughtbot-rcm &&
    sudo apt-get update &&
    sudo apt-get install rcm &&
    git clone --recursive https://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### On OSX

```bash
    cd $HOME &&
    brew tap thoughtbot/formulae &&
    brew install rcm &&
    git clone --recursive https://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### On Windows

Until the [WSL](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) is widely available, i'm using and supporting Cygwin.
Some notes on Cygwin you should read before continuing:

    I. Path:
    You  might want to remove applications from `$PATH` that provide Windows versions of unix tools e.g. Git for Windows.
    The latter will autocrlf, for instance, which means trying to read these CRLF files in a unix environment like Cygwin leads to headaches unless you `dos2unix` each file.  
    
    II. Symlinks:
    Cygwin creates "fake" symlinks by default which Windows cannot read.
    So, if, like me, you want to be able to use the dotfiles both in Cygwin and in normal Windows applications (e.g. git/ssh/gpg configs), you have two options:
      1) Use the `COPY_ALWAYS` option in .rcrc, for instance with the entry `COPY_ALWAYS="*"` to match every file.
       The obvious drawback is that any changes you make will not be automatically registered with the dotfiles repository. It's also slower when synchronizing.
      2) Tell Cygwin to use native NTFS symlinks. To do that, you'll have to `export CYGWIN="winsymlinks:native"` before running `rcup`.
       This is the method i use but it has two caveats:
        a) it requires administrator rights (i.e. start the Cygwin terminal emulator with "Run as administrator")
        b) it requires Windows Vista/2008 or later. Even then, native NTFS symlinks might behave strangely but this method is what works for me.


Since Cygwin doesn't come with an rcm package we'll have to build it manually.  
Please note that if you want your cygwin dotfiles to be usable by Windows applications, the following commands will need to be executed in a terminal with _elevated privileges_.

```bash
    export CYGWIN="winsymlinks:native" &&
    cd $HOME &&
    gem install mustache &&
    git clone --recursive https://github.com/thoughtbot/rcm.git &&
    cd rcm &&
    ./autogen.sh &&
    ./configure &&
    make &&
    make install &&
    git clone --recursive https://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### Portable installation script

You can create a portable installation script (e.g. for machines where you don't want to or can't install rcm) like this:

```bash
    rcup -B 0 -g -K > install.sh
```
It records all symlinks and install actions, apart from pre- and post-up-hooks, into a static script you can take with you.  

## Post-Install

### Configuration

There are a couple of settings you probably want to take a look at or modify after installing these dotfiles.

#### Gitconfig

Create or overwrite `~/.gitconfig.local` using your name, email and other personalized settings (e.g. gpg signing key).
```
[user]
    name = Your Name Here
    email = your@email.here
```

#### Profile

The file ~/.profile is sourced by both ZSH and Bash and is used to configure which modules are loaded, among other things.    
Make sure it suits your needs.  

#### Non-generic hosts

Some host configurations also come with X11 settings, found in ~/.xinitrc and ~/.xprofile as well as ssh, gnupg and other somewhat individualized configuration.  
If you're not using the `generic` profile, make sure you check those settings to avoid unexpected surprises.

### Customization

You can make your own customizations, of course, by editing files directly or alternatively by adding a new file with 
`.local` appended to the file name. These `.local` files will take precedence over their counterparts as they are loaded last.

Configuration files that accept `.local` overrides are:
  * ~/.tmux.conf (i.e. ~/.tmux.conf.local)
  * ~/.gitconfig
  * ~/.{bashrc,bash_profile,profile}
  * ~/.{zshrc,zpreztorc,zshenv,zprofile,zlogin,zlogout}
  * ~/.{vimrc,ideavimrc,cvimrc,vimperatorrc,pentadactylrc}

Additionally, there are a couple of special directories from which configuration files are automatically loaded.

  * ~/.bash/autoload/
  * ~/.zsh/autoload/
  * ~/.vim/autoload/
  
### Maintenance
  
Once a configuration is installed, e.g. via `rcup -B mbpro` the corresponding rcrc file (`~/.dotfiles/host-mbpro/rcrc`)
will be symlinked to `~/.rcrc` so that you don't have to specify the dotfiles directory or host name anymore.
Maintenance then simply becomes:
```
  cd ~/.dotfiles
  git pull
  rcup -v
  ```
There is also a shell alias `rcupd` which does that for you and can be used exactly like `rcup`:
```bash
    rcupd() {
        cd ~/.dotfiles
        git pull
        rcup -v "$@"
        cd -
    }
```

## Startup files

### Bash
Load order for (interactive, non-login) bash is:
   1. ~/.bashrc
   2. ~/.profile
   3. ~/.bash/init.bash (which will load scripts in ~/.bash/autoload)
   4. ~/.profile.local
   5. ~/.bashrc.local

### Zsh
Load order for (interactive, non-login) zsh is:
   1. ~/.zshenv
   2. ~/.zshenv.local
   3. ~/.zshrc
   4. ~/.zpreztorc
   5. ~/.zpreztorc.local
   6. ~/.profile
   7. ~/.bash/init.bash
   8. ~/.zsh/init.zsh
   9. ~/.profile.local
   10. ~/.zshrc.local

## Features

Coming soon.

### Solarized
### Vim
### Tmux
### Awesome
### OSX
### Shell
#### Fasd
#### Bash
#### Zsh

## Inspirations
There are a lot of great dotfiles repository already out there, some of which have had a strong influence on this project.  
Whether you are looking for inspiration or just want to shop around for alternatives, be sure to check out these remarkable dotfiles:  
  * [mathiasbynens](https://github.com/mathiasbynens/dotfiles)
  * [pbrisbin](https://github.com/pbrisbin/dotfiles)
  * [thoughtbot](https://github.com/thoughtbot/dotfiles)
  * [skwp/yadr](https://github.com/skwp/dotfiles)
  * [holman](https://github.com/holman/dotfiles)
  * [tpope](https://github.com/tpope/tpope)
  * [dotphiles](https://github.com/dotphiles/dotphiles)
  * [cowboy](https://github.com/cowboy/dotfiles)
  * [paulmillr](https://github.com/paulmillr/dotfiles)
  * [eduardolundgren](https://github.com/eduardolundgren/dotfiles)
  * [xero](https://github.com/xero/dotfiles)
  * [atomantic](https://github.com/atomantic/dotfiles)
  * [andschwa](https://github.com/andschwa/dotfiles)  

