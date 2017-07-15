" .vimrc
" Caleb Evans

" Disable highlighting of parens
:let loaded_matchparen = 1

" Set maximum line length (based on recommmended limit for Git commit messages)
" See http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
:set textwidth=72
" Automatically wrap words as close as possible without exceeding limit
:set formatoptions+=t

" Enable ruler showing current line and column
:set ruler

" Enable auto-indent (i.e. hanging indent behavior) for all file types
:set autoindent

" Reflow text to fit within the max line length
" To run within Vim, type "@r" (case-insensitive) in normal mode
:let @r='(V)gq'

" Git rebase key bindings

" Allow ctrl-s and ctrl-q to be used as key bindings
silent !stty -ixon
" Fixup (ctrl-f)
:map <buffer> <C-F> :s/^\(pick\\|reword\\|edit\\|squash\)/fixup/<CR>
" Squash (ctrl-s)
:map <buffer> <C-S> :s/^\(pick\\|reword\\|edit\\|fixup\)/squash/<CR>
" Edit (ctrl-e)
:map <buffer> <C-E> :s/^\(pick\\|reword\\|squash\\|fixup\)/edit/<CR>
" Reword (ctrl-r)
:map <buffer> <C-R> :s/^\(pick\\|edit\\|squash\\|fixup\)/reword/<CR>
" Pick (ctrl-p)
:map <buffer> <C-P> :s/^\(reword\\|squash\\|fixup\\|edit\)/pick/<CR>

" Enable syntax highlighting
syntax enable
syntax reset

" Syntax highlighting

" Available highlight groups
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#highlight-groups

" The following highlighting rules apply to both commits and merges

" Git commit summary
highlight Normal ctermfg=LightGray
highlight gitcommitSummary ctermfg=LightGray

" Git commit errors
highlight Error ctermfg=Red
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
