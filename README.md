# dotfiles
*Copyright 2017, Caleb Evans*  
*Released under the MIT license*

This repository describes and features the configuration files for my Terminal,
as well as configuration for the applications and packages I use. Note that I am
an avid OS X user, and therefore the majority of these customizations are
specific to OS X. However, many of these customizations can also be applied on
Linux systems.

## Terminal configuration

### Bash 4

OS X ships with Bash 3.2, however I use Bash 4 as my shell of choice. Bash 4
adds Unicode literals, the new *globstar* option, and support for Bash
Completion 2. These reasons are enough for me to use Bash 4 over the bundled
v3.2 shell.

### Theme

For my work in the Terminal, I created Material Colors, a minimalist theme which
utilizes Google's Material Design color palette. While the theme's
characteristics are largely founded in my personal tastes, I have chosen to
include the theme in this repository for your convenience at `terminal/themes/Material Colors.terminal`.

### Interactive prompt

The `PS1` interactive prompt which I have set for my shell is intended to be
concise, readable, and useful. The prompt displays the name of the current
working directory, followed by the name of the current branch if the directory
is a git repository. If the directory contains a `.virtualenv` directory, the
prompt also displays `py2` or `py3` depending on the virtualenv's Python
version. The prompt uses colons as separators, and spacing is utilized to
improve readability.

#### Examples

* `~ : $`
* `my-dir : $`
* `my-repo : master : $`
* `my-python-proj : py3 : master : $`

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

## Atom configuration

I use [Atom](https://atom.io/) as my editor of choice for editing text files and
writing code. My Atom configuration, included in this repository, features my
main configuration, preferred keymaps and snippets, as well as my initialization
script and custom styles.

### Emmet configuration

I have also included my configuration for [Emmet](http://emmet.io/), an
invaluable package which enables quick HTML expansion within Atom. This
configuration is located under the `emmet/` directory, and consists of both
preferences and snippets for HTML expansion.

Please ensure that the `~/dotfiles/emmet` directory is set as your *Extensions
Path* within the Emmet package preferences, because this directory is where my
Atom configuration expects to find user configuration for Emmet. Executing the
`setup/create_symlinks.sh` script will create the `~/dotfiles` directory.

### Python virtualenv activation

When you open in Atom a project directory containing a Python virtualenv, Atom
will automatically activate that virtualenv. This ensures that Atom packages
like [linter-flake8](https://atom.io/packages/linter-flake8) can use any
available Python packages in your project's virtualenv.

## Setup scripts

I have also created a series of scripts which automatically configure my shell,
set my preferred OS X preferences, install packages, and so forth. All of these
scripts are located under the `setup/` directory. You can run these scripts
altogether via `setup_all.sh`, or individually by executing the respective
script.

These scripts are generally useful for configuring fresh OS X installs, however
they are also designed to be re-run as needed. For instance,
`create_symlinks.sh` will ensure that the home directory symlinks to these
dotfiles are all up to date. In addition, `install_packages.sh` installs those
preferred Homebrew packages which are missing from the current system.
