" syntax/prm.vim
" Vim syntax file
"
" Language: prm
" Version: 0
" TODO: add stuff

" Match keywords
syntax keyword prmKeywords
      \ set
syntax keyword prmBoolean
      \ true
      \ false

" Match numbers
" like: 4, 4,3, 1e-4
syntax match prmNumber "\v<\d+>"
syntax match prmNumber "\v<\d+\.\d+>"
syntax match prmNumber "\v<\d*\.?\d+([Ee]-?)?\d+>"

" Match strings
" Allow escaped "
syntax region prmString start=/"/ skip=/\\"/ end=/"/ oneline

" Match subsections

" Set highlights
" :help group-name
highlight default link prmKeywords Keyword
highlight default link prmBoolean Boolean
highlight default link prmNumber Number
highlight default link prmString String
highlight default link prmSubsection Structure

