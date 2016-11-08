" indent/prm.vim
" Indent and folding
" Language: prm

setlocal autoindent sw=2 et
setlocal indentexpr=GetLineIndent()
setlocal indentkeys=o,O,*<Return>,=end

setlocal foldmethod=expr
setlocal foldexpr=PrmFoldExpr()

setlocal foldtext=PrmFoldText()
setlocal fillchars=  "

" set this small (0~2) to start with some folds closed
setlocal foldlevel=20

function! GetLineIndent(...)
  " Get the indent of line lnum.
  " check for optional second argument
  if a:0 > 0
    let lnum = a:1
  else
    let lnum = v:lnum
  end
  let topln = prevnonblank(lnum-1)
  if topln == 0
    return 0
  endif
  let indent = idtop
  if IsLineEndKeyword(lnum)
    let indent = idnow <= idtop - &sw  ? idnow : idtop - &sw
  endif
  if IsLineSubsectionKeyword(topln) 
    let indent = idnow >= idtop + &sw ? idnow : idtop + &sw
  endif
  return indent
endfunction

function! IsLineEndKeyword(lnum)
  " Returns 1 iff this line contains the end keyword
  let line = substitute(substitute(getline(lnum),'\s\+$','',''),'^\s\+','','')
  return line =~# '\v^\s*%(end)>'
endfunction

function! IsLineSubsectionKeyword(lnum)
  " Returns 1 iff this line contains the subsection keyword
  let line = substitute(substitute(getline(lnum),'\s\+$','',''),'^\s\+','','')
  return line =~# '\v^\s*%(subsection)>'
endfunction

function! PrmFoldExpr(...)
  " Determine the folding structure of the code
  "
  " determine whether to use the first argument of v:lnum
  " allowing use to call this function directly or use it as foldexpr
  if a:0 > 0
    let lnum = a:1
  else
    let lnum = v:lnum
  endif
  " determine folding
  if IsLineSubsectionKeyword(lnum)
    let f = '>1'
  elseif IsLineEndKeyword(lnum)
    let f = '<1'
  else
    " this is normal inner content, intelligently calculate ident
    let f = foldlevel(prevnonblank(lnum-1))
  endif
endfunction

function! PrmFoldText()
  " Returns a string which the folded text block will be collapsed into,
  " featuring the first line of the block, the number of lines folded up, and
  " the percentage of the file which this fold comprises.
  "
  " get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:folded
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif
  let w = winwidth(0) - &foldcolumn - (&number ? 4 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = ' '
  let lineCount = line("$")
  let foldPercentage = printf("[%lf", (foldSize*1.0)/lineCount*100) . "%] "
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
  return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
