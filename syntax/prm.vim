" syntax/prm.vim
" Vim syntax file
"
" Language: prm
" Version: 0
" TODO: add stuff

" Match keywords
syntax keyword prmSet set nextgroup=prmItemTitle skipwhite
syntax keyword prmSubsection subsection nextgroup=prmSubsectionTitle skipwhite
syntax keyword prmEndSubsection end
syntax keyword prmBoolean true false True False

" Additional keywords
syntax keyword prmSymbols x y z 
      \ gmres cg 
      \ quiet verbose
      \ pressure reflective
      \ constant

" Using \i instead of \w, which matches more characters
syntax match prmSubsectionTitle '\i.\+$' contained
syntax match prmItemTitle '\i.\+=' contained
" Match comments
syn match prmComment "#.*$"

" Match numbers
" like: 4, 4,3, 1e-4
syntax match prmInteger "\v<\d+>"
syntax match prmFloat "\v<\d+\.\d+>"
syntax match prmFloat "\v<\d*\.?\d+([Ee]-?)?\d+>"

" Filenames
syntax match prmFilename "\v<\w+\.\w+>"

" Match operators
syntax match prmOperator "[+-/><()\*]"


" Set highlights
" :help group-name
highlight default link prmSet Function
highlight default link prmComment Comment
highlight default link prmBoolean Boolean
highlight default link prmSubsection Structure
highlight default link prmEndSubsection Structure
highlight default link prmSubsectionTitle Todo
highlight default link prmItemTitle Keyword

" Unified color for rhs
highlight default link prmSymbols Number
highlight default link prmFilename Number
highlight default link prmInteger Number
highlight default link prmFloat Number
highlight default link prmOperator Number


