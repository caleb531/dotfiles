" .vimrc
" Caleb Evans

" Disable highlighting of parens
:let loaded_matchparen = 1

" Set maximum line length (based on recommmended limit for Git commit messages)
" See http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
:set tw=72
" Automatically wrap words as close as possible without exceeding limit
:set formatoptions+=t

" Enable ruler showing current line and column
:set ruler

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
