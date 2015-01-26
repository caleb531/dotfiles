# dotfiles
*Copyright 2015, Caleb Evans*  
*Released under the MIT license*

## Introduction

This repository describes and features not only my shell configuration files (*i.e.* dotfiles) but also my overall Terminal setup. Note that I am an avid OS X user, and so a number of these customizations and instructions are specific to OS X. However, many of these customizations can also be applied to other UNIX systems.

## Features

### Bash 4

OS X ships with Bash 3.2, however I use Bash 4 as my shell of choice. Bash 4 offers support for Unicode literals, and the more-performant Bash Completion 2 requires Bash 4.2 or newer. These reasons are enough for me to use Bash 4 over the bundled v3.2 shell.

### Terminal theme

I've included my preferred Terminal theme, a modified version of the [IR_Black theme](http://toddwerth.com/2011/07/21/the-original-ir_black-for-os-x-lion) which I call IR_Better. IR_Better features a few modest improvements over IR_Black, including an 80x20 window size and additional key bindings. While most of these changes are founded in my personal tastes, I have still chosen to include the theme (with screenshots) in this repository for your convenience.

### Packages

I use [Homebrew](http://brew.sh/) as my preferred package manager, which enables me to install all other packages required for my shell setup.

### Completion

I use Bash Completion 2.1 for tab completion on the command line. Bash Completion 2 offers significant performance advantages over its predecessor (v1.3), making it the optimal choice for my completion needs.

### Color highlighting

My setup enables color highlighting for a number of commands and interfaces. These include:

* `diff`
* `grep`, `egrep`, `fgrep`
* `less`
* `ls`

My setup also applies color highlighting when editing Git commit or merge messages in Vim.

### Interactive prompt

The `PS1` interactive prompt which I have set for my shell is intended to be concise, readable, and useful. The prompt displays the name of the current working directory, followed by the name of the current branch (if the directory is a git repository). Colons are used as separators, and spacing is utilized to improve readability.

#### Examples

* `~ : $`
* `my-dir : $`
* `my-repo : master : $`

## Setup Procedure

### Create symlinks

I recommend cloning this repository to the directory of your choice, preferrably using some cloud syncing service such as Dropbox. Then, you should create symlinks within your home directory pointing to the necessary files. These files include:

* `bash_profile`
* `vimrc`

### Install Homebrew

You can install Homebrew using the following command:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

My `bash_profile` expects that your Homebrew cellar is located in `/usr/local/bin`. If you've already symlinked my `bash_profile` to your home directory, then `/usr/local/bin` will already be at the front of your PATH.

### Install Bash 4

To install and use Bash 4 as the default shell for OS X, proceed through the following steps:

#### Install latest version of Bash 4

```
brew install bash
```

#### Set Bash 4 as login shell

```
sudo chsh -s /usr/local/bin/bash $USER
```

### Install Bash Completion 2

Recall that Bash Completion 2 requires Bash 4.2 or newer.

```
brew install homebrew/versions/bash-completion2
```

Note that if you installed Git prior to installing Bash Completion, Git may not automatically install its completions. If this is the case, reinstalling Git should add the completions.

```
brew reinstall git
```

### Colorize `diff`

In my `bash_profile`, I alias `diff` to `colordiff` if the latter is installed. Therefore, if you desire to enable color highlighting for `diff` output, install the `colordiff` package via Homebrew:

```
brew install colordiff
```

### Install GNU `grep`

The GNU version of `grep` supports Perl regular expressions (PCRE) via the `-P` option. Installing the `grep` via Homebrew will enable this functionality.

```
brew install homebrew/dupes/grep --with-default-names
```

### Install `tree`

The `tree` command is useful for quickly listing the full hierarchy of a directory. You can also install it via Homebrew:

```
brew install tree
```

### Install GNU `ls`

My `bash_profile` uses the GNU flavor of `ls`, which supports colorizing `ls` output in a manner consistent with `grep` and `tree`. Installing it requires installing the `coreutils` package via Homebrew:

```
brew install coreutils
``

Also note that `/usr/local/opt/coreutils/libexec/gnubin` needs to exist on your PATH (before `/bin`, of course). Fortunately, my `bash_profile` already does so for your convenience.
