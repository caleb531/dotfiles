""".vimrc
""" Caleb Evans

" Enable syntax highlighting
syntax enable
syntax reset

"" Syntax highlighting

" Available highlight groups
" http://vimdoc.sourceforge.net/htmldoc/syntax.html#highlight-groups

" Git commit summary
highlight gitcommitSummary ctermfg=Green
" Git commit summary (overflowing text)
highlight gitcommitOverflow ctermfg=Red
" Git commit error messages
highlight gitcommitBlank ctermfg=DarkRed
" Git commit comment
highlight gitcommitComment ctermfg=DarkGray
" Git commit branch names
highlight gitcommitBranch ctermfg=White
" Git commit branch message ('on branch...')
highlight gitcommitOnBranch ctermfg=White
" Git commit header message ('changes to be...')
highlight gitcommitHeader ctermfg=White
" Git commit type (modified, untracked, etc.)
highlight gitcommitType ctermfg=DarkGreen
" Git commit filename
highlight gitcommitFile ctermfg=DarkGreen
