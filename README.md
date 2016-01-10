dotfiles
===================

Cross-platform multi-host configuration files managed with [rcm](https://github.com/thoughtbot/rcm).
I use these with OSX, (Arch-)Linux and Cygwin under Windows 10.

Installation on ArchLinux
-------------------------
    
    cd $HOME
    clone https://aur.archlinux.org/rcm-git.git && cd rcm-git
    makepkg -i
    git clone git://github.com/mikar/dotfiles.git $HOME/.dotfiles
    ln -s $HOME/.dotfiles/host-w541/rcrc $HOME/.rcrc
    rcup

Installation on OSX
-------------------

    cd $HOME
    brew tap thoughtbot/formulae
    brew install rcm
    git clone git://github.com/mikar/dotfiles.git $HOME/.dotfiles
    ln -s $HOME/.dotfiles/host-w541/rcrc $HOME/.rcrc
    rcup

Customization
----------------------------

You can make your own customizations by adding `.local`files. 
They will take precedence over their counterparts as they are loaded last.
For instance, to extend `.zshrc` you can make your changes in `.zshrc.local`.

To extend your `git` hooks, create executable scripts in
`~/.git_template.local/hooks/*` files.

Additional zsh configuration can go under the `~/.zsh/configs` directory. This
has two special subdirectories: `pre` for files that must be loaded first, and
`post` for files that must be loaded last.

What's in it?
-------------

[vim](http://www.vim.org/) configuration:

* [Ctrl-P](https://github.com/kien/ctrlp.vim) for fuzzy file/buffer/tag finding.
* Set `<leader>` to a single space.
* Switch between the last two files with space-space.
* Syntax highlighting for CoffeeScript, Textile, Cucumber, Haml, Markdown, and
  HTML.
* Use [vim-mkdir](https://github.com/pbrisbin/vim-mkdir) for automatically
  creating non-existing directories before writing the buffer.
* Use [vim-plug](https://github.com/junegunn/vim-plug) to manage plugins.

[tmux](http://robots.thoughtbot.com/a-tmux-crash-course)
configuration:

* Improve color resolution.
* Remove administrative debris (session name, hostname, time) in status bar.
* Set prefix to `Ctrl+Space`
* Soften status bar color from harsh green to light gray.

[git](http://git-scm.com/) configuration:

* Adds a `create-branch` alias to create feature branches.
* Adds a `delete-branch` alias to delete feature branches.
* Adds a `merge-branch` alias to merge feature branches into master.
* Adds an `up` alias to fetch and rebase `origin/master` into the feature
  branch. Use `git up -i` for interactive rebases.
* Adds `post-{checkout,commit,merge}` hooks to re-index your ctags.
* Adds `pre-commit` and `prepare-commit-msg` stubs that delegate to your local
  config.

Shell aliases and scripts:

* `b` for `bundle`.
* `g` with no arguments is `hub status` and with arguments acts like `hub`.
* `git-churn` to show churn for the files changed in the branch.
* `mcd` to make a directory and change into it.
* `tat` to attach to tmux session named the same as the current directory.
* `v` for `$VISUAL`.

