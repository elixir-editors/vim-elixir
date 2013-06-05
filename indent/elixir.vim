" Vim indent file
" Language: Elixir
" Maintainer: Carlos Galdino <carloshsgaldino@gmail.com>
" Last Change: 2013 Apr 24

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal nosmartindent

setlocal indentexpr=GetElixirIndent(v:lnum)
setlocal indentkeys+==end,=else:,=match:,=elsif:,=catch:,=after:,=rescue:

if exists("*GetElixirIndent")
  finish
endif

let s:elixir_indent_keywords = '\%(\<\(case\|if\|unless\|try\|loop\|receive\)\>\|' .
      \ '^\s*\(defmodule\|defimpl\|defmacro\|defdelegate\|defexception\|defcallback\|defoverridable\|defp\|def\|test\|[a-z]\w*\(:\)\@=\)\|' .
      \ 'fn(.*)\s\(do\|->\)$\)'

let s:elixir_clauses = '\(else\|match\|elsif\|catch\|after\|rescue\):\|end'

function! s:BlockStarter(lnum, block_start_re)
   let lnum = a:lnum
   let maxindent = 10000
   while lnum > 1
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
     let lnum = prevnonblank(lnum - 1)
   endwhile
   return -1
 endfunction

function! GetElixirIndent(line_num)
  " don't indent if it's the first line of the file
  if a:line_num == 0
    return 0
  endif

  let this_line = getline(a:line_num)

  if this_line =~ s:elixir_clauses
    let bslnum = s:BlockStarter(a:line_num, s:elixir_indent_keywords)
    if bslnum > 0
      return indent(bslnum)
    else
      return -1
    endif
  endif

  let plnum = a:line_num - 1
  let previous_line = getline(plnum)

  if previous_line =~ '\(do\|when\|->\)$\|^\s*\(if\>\|[a-z]\w*\(:\)\@=\)'
    return indent(plnum) + &sw
  endif

  " blank lines are indented based on the previous not blank line"
  if previous_line =~ '^\s*$'
    let nonblank = prevnonblank(a:line_num)
    return indent(nonblank)
  endif

  return indent(plnum)
endfunction
