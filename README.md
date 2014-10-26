# dotfiles
*Caleb Evans*

## Introduction

My shell setup is optimized for efficiency and convenience, yet only to the degree that I actually use the shell.

## Features

### Shells

I use Bash 3.2 as my preferred shell, mainly because this is the version of Bash which comes comes bundled with OS X.

### Packages

I use [Homebrew](http://brew.sh/) as my package manager of choice. With it, I can install most of the other packages required for my shell setup.

### Autocompletion

I use Bash Completion 1.3 for tab autocompletion on the command line. I do not use version 2.0 because it requires Bash 4.2.

I also use a third-party script called [bash dyncompletion](http://fahdshariff.blogspot.com/2011/09/speeding-up-bash-profile-load-time.html), which preloads completions as needed to improve startup performance significantly.

### Color highlighting

My `.bash_profile ` enables color highlighting for a number of commands and interfaces. These include:

* `diff`
* `grep`
* `less`
* `ls`

My setup also applies color highlighting when editing the message for a git commit or merge in Vim.

### Interactive prompt

The `PS1` interactive prompt which I have set for my shell is intended to be concise, readable, and useful. The prompt only displays the name of the current working directory, followed by the name of the current branch (if the directory is a git repository). Spacing is also utilized to improve readability.

#### Examples

* `~ : $`
* `my-dir : $`
* `my-repo : master : $`

## Setup

### Install Homebrew

You can install Homebrew via Ruby:

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

The `.bash_profile` expects that your Homebrew cellar is located at `/usr/local/bin`. Ensure that you have sufficient privileges to write to this directory.

### Install Bash Completion

```
brew install bash-completion
```

Upon installing Bash Completion, you also need to run `dyncomp.sh`, which is included in this repository for your convenience. This script only needs to be run once *and* whenever you add/update/remove completion definitions.

### Colorize `diff`

In my `.bash_profile`, I alias `diff` to `colordiff` if the latter is installed. Therefore, if you desire to have enable color-coding for diff output, install the `colordiff` package via Homebrew:

```
brew install colordiff
```