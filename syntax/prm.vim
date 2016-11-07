" syntax/prm.vim
" Vim syntax file
"
" Language: prm
" Version: 0
" TODO: add stuff

" Match keywords
syntax keyword prmKeywords set
syntax keyword prmBoolean true false True False
syntax keyword prmSubsection

" Match comments
syn match prmComment "#.*$"

" Match numbers
" like: 4, 4,3, 1e-4
syntax match prmInteger "\v<\d+>"
syntax match prmFloat "\v<\d+\.\d+>"
syntax match prmFloat "\v<\d*\.?\d+([Ee]-?)?\d+>"

" Match operators
syntax match prmOperator "[+-]"

" Match subsections

" Set highlights
" :help group-name
highlight default link prmKeywords Keyword
highlight default link prmComment Comment
highlight default link prmBoolean Boolean
highlight default link prmInteger Number
highlight default link prmFloat Float
highlight default link prmString String
highlight default link prmOperator Operator
highlight default link prmSubsection Structure


