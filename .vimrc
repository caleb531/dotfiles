" .vimrc
" Caleb Evans

" Enable syntax highlighting
syntax enable
syntax reset

"" Syntax highlighting

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
highlight Type ctermfg=DarkGreen
highlight gitcommitType ctermfg=DarkGreen

" Git commit filename
highlight gitcommitFile ctermfg=DarkGreen

" Git commit arrow (for indicating renames and such)
highlight gitcommitArrow ctermfg=DarkGreen
