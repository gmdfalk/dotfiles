# dotfiles

Modular cross-platform multi-host configuration files managed with [rcm](https://github.com/thoughtbot/rcm).

## About

I use these dotfiles on all my machines running OSX, (Arch-)Linux and Windows 7/10 (w/ Cygwin64).
If you are a developer, need cross-platform dotfiles and/or like the vim/solarized combo, these dotfiles might be for you!

Features:
  * Portable between OSX, Linux and Windows
  * Shared configuration between bash and zsh
  * Vim-centric key bindings
  * Solarized colors, when possible

Frameworks/Libraries:
  * zsh: [prezto](https://github.com/sorin-ionescu/prezto)/[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
  * bash: [bash-it](https://github.com/Bash-it/bash-it)
  * tmux: [tpm](https://github.com/tmux-plugins/tpm)
  * vim: [vim-plug](https://github.com/junegunn/vim-plug)
  * firefox: [pentadactyl](https://github.com/5digits/dactyl)/[vimperator](https://github.com/vimperator/vimperator-labs)
  * shell: [fasd](https://github.com/clvv/fasd)

Inspirations:
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
  * and many more

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
    clone https://aur.archlinux.org/rcm-git.git && cd rcm-git &&
    makepkg -i &&
    git clone --recursive git://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### On OSX

```bash
    cd $HOME &&
    brew tap thoughtbot/formulae &&
    brew install rcm &&
    git clone --recursive git://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

### On Windows

Cygwin doesn't come with a rcm package so we'll have to build it.

```bash
    cd $HOME &&
    git clone --recursive git://github.com.com/thoughtbot/rcm.git && cd rcm &&
    ./autogen.sh &&
    ./configure &&
    make &&
    make install &&
    git clone --recursive git://github.com/mikar/dotfiles.git $HOME/.dotfiles &&
    rcup -B generic -v
```

A note on symlinks:  
Please note that Cygwin creates "fake" symlinks by default which Windows cannot read.
So, if, like me, you want to be able to use the dotfiles both in Cygwin and in normal Windows applications (e.g. git/ssh/gpg configs), you have two options:
1) Use the `COPY_ALWAYS` option in .rcrc, for instance with the entry `COPY_ALWAYS="*"` to match every file.
   The obvious drawback is that any changes you make will not be automatically registered with the dotfiles repository. It's also slower when synchronizing.
2) Tell Cygwin to use native NTFS symlinks. To do that, you'll have to `export CYGWIN="winsymlinks:native"` before running `rcup`.
   This is the method i use but it has two caveats:
   a) it requires administrator rights (i.e. start the Cygwin terminal emulator with "Run as administrator" and
   b) it requires Windows Vista/2008 or later. Even then, native NTFS symlinks might behave strangely but this method is what works for me.

A word on `$PATH`:
You  might want to remove applications from `$PATH` that provide Windows versions of unix tools e.g. Git for Windows.
The latter will autocrlf, for instance, which means trying to read these CRLF files in a unix environment like Cygwin leads to headaches unless you `dos2unix` each file.

### Portable installation script

You can create a portable installation script (e.g. for machines where you don't want to or can't install rcm) like this:

```bash
    rcup -B 0 -g -K > install.sh
```

## Post-Install

### Maintenance

Once a configuration is installed, e.g. via `rcup -B generic` the corresponding rcrc file (`~/.dotfiles/host-generic/rcrc`)
will be symlinked to `~/.rcrc` so that you don't have to specify the dotfiles directory or host name anymore.
Maintenance then simply becomes:
```
cd ~/.dotfiles
git pull
rcup -v
```

### Configuration

There are a couple of configurations you probably want to do after installing this repository as outlined above.

#### Git

Add a `~/.gitconfig.local` with your name, email and whatever else you want to add to your local gitconfig.  
```
[user]
    name = Your Name Here
    email = your@email.here
```

## Customization

You can make your own customizations, of course, by editing files directly or alternatively by adding a new file with 
`.local` appended to the file name. These `.local` files will take precedence over their counterparts as they are loaded last.

Configuration files that accept `.local` overrides are:
  * ~/.tmux.conf (i.e. ~/.tmux.conf.local)
  * ~/.gitconfig
  * ~/.zshrc
  * ~/.vimrc
  * ~/.pentadactylrc
  * ~/.vimperatorrc
  * ~/.cvimrc
  * ~/.ideavimrc

Additionally, there are a couple of special directories from which configuration files are automatically loaded.

  * ~/.bash/custom/{pre-autoload,pre,post,post-autoload} (in load order)
  * ~/.zsh/custom/{pre-autoload,pre,post,post-autoload}

Load order for (interactive, non-login) bash is:
  1. ~/.bash_profile
  2. ~/.bash_profile.local
  3. ~/.profile
  5. ~/.profile.local
  4. ~/.bash/custom/init.bash (which will load scripts in ~/.bash/custom/{pre-autoload,pre,post,post-autoload} folders)
  6. ~/.bashrc
  7. ~/.bashrc.local

Load order for (interactive, non-login) zs is:
  1. ~/.zshenv
  2. ~/.zshenv.local
  3. ~/.zprofile (on first start)
  4. ~/.profile
  5. ~/.profile.local
  6. ~/.bash/custom/init.bash
  7. ~/.zsh/custom/init.zsh
  8. ~/.zshrc
  9. ~/.zshrc.local

## Features

### Solarized
### Bash
### Zsh
### Vim
### Scripts
### Tmux
### Awesome
### OSX

Coming soon.

