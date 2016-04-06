# dotfiles
*Copyright 2016, Caleb Evans*  
*Released under the MIT license*

## Introduction

This repository describes and features the configuration files for my Terminal,
as well as configuration for the applications and packages I use. Note that I am
an avid OS X user, and therefore most of these customizations are specific to OS
X. However, some of these customizations can also be applied on Linux systems.

## Features

### Bash 4

OS X ships with Bash 3.2, however I use Bash 4 as my shell of choice. Bash 4
adds Unicode literals, the new *globstar* option, and support for Bash
Completion 2. These reasons are enough for me to use Bash 4 over the bundled
v3.2 shell.

### Completion

I use Bash Completion 2.1 for tab completion on the command line. Bash
Completion 2 offers significant performance advantages over its predecessor
(v1.3), making it the optimal choice for my completion needs.

### Terminal theme

For my work in the Terminal, I created Material Colors, a minimalist theme which
utilizes Google's Material Design color palette. While the theme's
characteristics are largely founded in my personal tastes, I have chosen to
include the theme in this repository for your convenience at `terminal/themes/Material Colors.terminal`.

### Color highlighting

My setup enables color highlighting for a number of commands and interfaces,
including:

* `diff`
* `grep`, `egrep`, `fgrep`
* `less`
* `ls`
* `tree`

My setup also applies color highlighting when editing Git commit or merge
messages in Vim.

### Python virtualenv switching

If you open or `cd` into a current working directory contains a Python
virtualenv (under the name `.virtualenv`), my Bash configuration will
automatically activate that virtualenv. When you `cd` to another directory, that
currently-active virtualenv will be automatically deactivated (and of course,
any virtualenv present in the new directory will be activated).

### Interactive prompt

The `PS1` interactive prompt which I have set for my shell is intended to be
concise, readable, and useful. The prompt displays the name of the current
working directory, followed by the name of the current branch if the directory
is a git repository. If the directory contains a `.virtualenv` directory, the
prompt also displays `python` or `python3` depending on the virtualenv's Python
version. The prompt uses colons as separators, and spacing is utilized to
improve readability.

#### Examples

* `~ : $`
* `my-dir : $`
* `my-repo : master : $`

## Atom configuration

I use [Atom](https://atom.io/) as my editor of choice for editing text files and
writing code. My Atom configuration, included in this repository, features my
main configuration, preferred keymaps and snippets, as well as my initialization
script and custom styles.

### Lightweight package sync

Like most of my files, I sync my Atom configuration via Dropbox, including my
Atom packages. However, I did not wish to store my entire `packages` directory
in Dropbox, because the directory would add a great deal of weight to my Dropbox
(in terms of file size and number of files).

To solve this issue, I crafted a lightweight syncing system which only required
that I store in Dropbox a list of the packages I use. Whenever I installed or
uninstalled a package within Atom (or via `apm`), this list would be updated to
reflect those changes. Then, when I launch Atom (or run `apm pull`) on another
one of my machines, those recently-added or -removed packages are respectively
installed or uninstalled, completely automatically.

### Emmet configuration

I have also included my configuration for [Emmet](http://emmet.io/), an
invaluable package which enables quick HTML expansion within Atom. This
configuration consists of both preferences and snippets for HTML/CSS expansion.

Please ensure that the `~/.emmet` directory is set as your *Extensions Path*
within the Atom package's preferences, because this directory is where my Atom
configuration expects to find user configuration for Emmet.

### Python virtualenv activation

When you open in Atom a project directory containing a Python virtualenv, Atom
will automatically activate that virtualenv.

## Configuration scripts

For configuring fresh OS X installs, I have also created a series of scripts
which automatically configure my shell, set my preferred OS X preferences, and
install packages, among other tasks. All of these scripts are located within the
`config/` directory. You can run these scripts altogether using `config-all.sh`,
or individually by executing the respective script.

Generally, it is most useful to execute `config/create-symlinks.sh`, which will
forcefully create/update the respective symlinks to these dotfiles within your
home directory.
