" .vimrc
" Caleb Evans

" Disable highlighting of parens
let loaded_matchparen=1

" Set maximum line length (based on recommmended limit for Git commit messages)
" See <http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html>
set textwidth=72
" Automatically wrap words as close as possible without exceeding limit
set formatoptions+=t

" Enable ruler showing current line and column
set ruler

" Enable auto-indent (i.e. hanging indent behavior) for all file types
set autoindent

" Ensure the backspace key always functions as delete in insert mode (strangely,
" it doesn't by default for brew-installed vim)
set backspace=indent,eol,start

" Reflow text to fit within the max line length
" To run within Vim, type "@r" (case-insensitive) in normal mode
let @r='(V)gq'

" Git rebase key bindings

" Allow ctrl-s and ctrl-q to be used as key bindings
silent !stty -ixon
" Pick (ctrl-p)
map <buffer> <C-p> :s/^[[:alpha:]]\+/pick/<CR>
" Reword (ctrl-r)
map <buffer> <C-r> :s/^[[:alpha:]]\+/reword/<CR>
" Edit (ctrl-e)
map <buffer> <C-e> :s/^[[:alpha:]]\+/edit/<CR>
" Squash (ctrl-s)
map <buffer> <C-s> :s/^[[:alpha:]]\+/squash/<CR>
" Fixup (ctrl-f)
map <buffer> <C-f> :s/^[[:alpha:]]\+/fixup/<CR>

" Move line up with ctrl-a
map <buffer> <C-a> :m-2<CR>
" Move line down with ctrl-z
map <buffer> <C-z> :m+1<CR>


" Comment line with ctrl-c
map <buffer> <C-c> :norm i#<CR>
" Uncomment line with ctrl-v
map <buffer> <C-v> :norm x<CR>

" Enable syntax highlighting
syntax enable
syntax reset

" Syntax highlighting

" Available highlight groups
" See <http://vimdoc.sourceforge.net/htmldoc/syntax.html#highlight-groups>

" The following highlighting rules apply to both commits and merges

" Git commit summary
highlight Normal ctermfg=LightGray
highlight gitcommitSummary ctermfg=LightGray

" Git commit errors
highlight Error ctermfg=DarkRed
highlight gitcommitBlank ctermfg=DarkRed

" Git commit overflowing summary
highlight gitcommitOverflow ctermfg=Red

" Git commit comment
highlight Comment ctermfg=DarkGray
highlight gitcommitComment ctermfg=DarkGray

" Git commit branch names
highlight Special ctermfg=White
highlight Constant ctermfg=White
highlight gitcommitBranch ctermfg=White

" Git commit branch message ('on branch...')
highlight gitcommitOnBranch ctermfg=LightGray

" Git commit header message ('changes to be...')
highlight PreProc ctermfg=LightGray
highlight gitcommitHeader ctermfg=LightGray

" Git commit type (added, modified, etc.)
highlight Type ctermfg=DarkRed
highlight gitcommitType ctermfg=DarkRed
" Git commit type (staged files)
highlight gitcommitSelectedType ctermfg=DarkGreen

" Git commit filename
highlight gitcommitFile ctermfg=DarkRed
" Git commit filename (staged files)
highlight gitcommitSelectedFile ctermfg=DarkGreen

" Git commit arrow (for indicating renames and such)
highlight gitcommitArrow ctermfg=DarkRed
" Git commit arrow (staged files)
highlight gitcommitSelectedArrow ctermfg=DarkGreen
