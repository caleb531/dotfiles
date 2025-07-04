# dotfiles

*Copyright 2014-2025, Caleb Evans*  
*Released under the MIT license*

This repository describes and features the configuration files for my Terminal,
as well as configuration for the applications and packages I use. Note that I am
an avid macOS user, and therefore the majority of these customizations are
specific to macOS. However, many of these customizations can also be applied on
Linux systems.

## Terminal configuration

### Bash 5

macOS ships with Bash 3.2, however I use Bash 5 as my shell of choice. Bash 5
adds Unicode literals, the new *globstar* option, and support for Bash
Completion 2. These reasons are enough for me to use Bash 5 over the bundled zsh
shell (I also find zsh overrated, but that's just me).

### Theme

For my work in the Terminal, I created Monokai, a minimalist theme which
utilizes the Monokai color scheme. You may find the theme in this repository at
`terminal/themes/Monokai.terminal`.

### Interactive prompt

The `PS1` interactive prompt which I have set for my shell is intended to be
concise, readable, and useful. The prompt displays the name of the current
working directory, followed by the name of the current branch if the directory
is a git repository. If the directory contains a `.virtualenv` directory, the
prompt also displays `py2` or `py3` depending on the virtualenv's Python
version. Each component is displayed in a separate color to improve readability.

### Completion

I use Bash Completion 2.1 for tab completion on the command line. Bash
Completion 2 offers significant performance advantages over its predecessor
(v1.3), making it the optimal choice for my completion needs.

### Color highlighting

My setup enables color highlighting for a number of commands and interfaces,
including:

* `diff`
* `git diff` (highlights changes within lines)
* `grep`, `egrep`, `fgrep`
* `less`
* `ls`
* `tree`
* `vim` (when editing commit messages)

### Python virtualenv switching

If you open or `cd` into a current working directory contains a Python
virtualenv (under the name `.virtualenv`), my Bash configuration will
automatically activate that virtualenv. When you `cd` to another directory, that
currently-active virtualenv will be automatically deactivated (and of course,
any virtualenv present in the new directory will be activated).

## VS Code configuration

I use [VS Code](https://code.visualstudio.com/) as my editor of choice for
editing text files and writing code. My VS Code configuration, included in this
repository, features my main configuration, as well as preferred keymaps and
snippets.

### Emmet configuration

I have also included my configuration for [Emmet](http://emmet.io/), an
invaluable package which enables quick HTML expansion within VS Code. This
configuration is located under the `emmet/` directory, and consists of both
preferences and snippets for HTML expansion.

Please ensure that the `~/dotfiles/emmet` directory is set as your *Extensions
Path* within the Emmet package preferences, because this directory is where my
VS Code configuration expects to find user configuration for Emmet. Executing
the `setup/create_symlinks.sh` script will create the `~/dotfiles` directory.

## Setup scripts

I have also created a series of scripts which automatically configure my shell,
set my preferred macOS preferences, install packages, and so forth. All of these
scripts are located under the `setup/` directory. You can run these scripts
altogether via `setup_all.sh`, or individually by executing the respective
script.

These scripts are generally useful for configuring fresh macOS installs, however
they are also designed to be re-run as needed. For instance,
`create_symlinks.sh` will ensure that the home directory symlinks to these
dotfiles are all up to date. In addition, `install_packages.sh` installs those
preferred Homebrew packages which are missing from the current system.
