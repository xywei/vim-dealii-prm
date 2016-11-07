" indent/prm.vim
" Indent and folding
" Language: prm

setlocal foldmethod=expr
setlocal foldexpr=PrmFoldExpr()

setlocal foldtext=PrmFoldText()
setlocal fillchars=  "

" set this small (0~2) to start with some folds closed
setlocal foldlevel=20

function! GetLineIndent(lnum, ...)
  " Get the indent of line lnum.
  " Blank lines are considered indented by the maximum of their surrounding
  " lines' indents.
  "
  " The optional second argument is only used internally.
  "   =  1 to have forward recursion.
  "   = -1 to have backward recursion.
  " The only difference is in blank lines. When left default, it takes the
  " maximum in either direction.
  "
  " check for optional second argument
  if a:0 > 0
    let directionForward = a:1
  else
    let directionForward = 0
  end
  " dealing with blank lines
  if IsLineBlank(a:lnum)
    if directionForward == 0
      return max([GetLineIndent(nextnonblank(a:lnum+1),1), GetLineIndent(prevnonblank(a:lnum-1),-1)])
    elseif directionForward == 1
      return GetLineIndent(nextnonblank(a:lnum+1), 1)
    else " directionForward == -1
      return GetLineIndent(prevnonblank(a:lnum-1), -1)
    end
  else
    return indent(a:lnum)
  endif
endfunction

function! IsLineBlank(lnum)
  " Returns 1 iff this line is blank or contains only a comment
  return getline(a:lnum)=~'^\s*\(#.*\)*$'
endfunction

function! IsLineEndKeyword(lnum)
  " Returns 1 iff this line contains the end keyword
  " Possibly followed by a comment
  return getline(a:lnum)=~'^\s*end\s*\(#.*\)*$'
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
  " determin folding
  if lnum == 1
    " first line is always a fold (the root of the tree)
    let f = '>'.GetLineIndent(nextnonblank(lnum+1))
  elseif IsLineEndKeyword(lnum)
    " terminate the fold
    let f = '<'.GetLineIndent(prevnonblank(lnum-1))
  elseif GetLineIndent(lnum) < GetLineIndent(nextnonblank(lnum+1))
    " next line has greater indent, thus this line starts a new fold
    let f = '>'.GetLineIndent(nextnonblank(lnum+1))
  else
    " this is normal inner content, intelligently calculate ident
    let f = GetLineIndent(lnum)
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
