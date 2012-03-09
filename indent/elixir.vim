" Vim indent file
" Language: Elixir
" Maintainer: Carlos Galdino <carloshsgaldino@gmail.com>
" Last Change: 2012 Mar 9

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetElixirIndent(v:lnum)
setlocal indentkeys+==end,=else,=match

if exists("*GetElixirIndent")
  finish
endif

let s:elixir_indent_keywords = '^\s*\<\%(case\|if\|unless\|try\|loop\|receive\|' .
      \ 'fn\|defmodule\|defimpl\|defmacro\|defdelegate\|defexception\|defp\|def\|\(match\|else\)\(:\)\@=\)\>'

function! s:BlockStarter(lnum, block_start_re)
   let lnum = a:lnum
   let maxindent = 10000
   while lnum > 1
     let lnum = prevnonblank(lnum - 1)
     if indent(lnum) < maxindent
       if getline(lnum) =~ a:block_start_re
         return lnum
       else
         let maxindent = indent(lnum)
         if maxindent == 0
           return -1
         endif
       endif
     endif
   endwhile
   return -1
 endfunction

function! GetElixirIndent(line_num)
  " no indent if it's the first line of the file
  if a:line_num == 0
    return 0
  endif

  let this_line = getline(a:line_num)

  if this_line =~ '^\s*\(else\|end\|match\)\>'
    let bslnum = s:BlockStarter(a:line_num, s:elixir_indent_keywords)
    if bslnum > 0
      return indent(bslnum)
    else
      return -1
    endif
  endif

  let plnum = a:line_num - 1
  let previous_line = getline(plnum)

  if previous_line =~ '\(do\|when\)$\|^\s*\(if\>\|\(match\|else\)\(:\)\@=\)'
    return indent(plnum) + &sw
  endif

  return indent(plnum)
endfunction
