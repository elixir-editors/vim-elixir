" Only load this indent file when no other was loaded
if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal indentexpr=elixir#indent(v:lnum)

setlocal indentkeys+=0=end,0=catch,0=rescue,0=after,0=else,=->,0},0],0=\|>,0=<>
" TODO: @jbodah 2017-02-27:
" setlocal indentkeys+=0)
" TODO: @jbodah 2017-02-27: all operators should cause reindent when typed

function! elixir#debug(str)
  if exists("g:elixir_indent_debug") && g:elixir_indent_debug
    echom a:str
  endif
endfunction

" Returns 0 or 1 based on whether or not the text starts with the given
" expression and is not a string or comment
function! elixir#starts_with(text, expr, lnum)
  let pos = match(a:text, '^\s*'.a:expr)
  if pos == -1
    return 0
  else
    " NOTE: @jbodah 2017-02-24: pos is the index of the match which is
    " zero-indexed. Add one to make it the column number
    if elixir#is_string_or_comment(a:lnum, pos + 1)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the text ends with the given
" expression and is not a string or comment
function! elixir#ends_with(text, expr, lnum)
  let pos = match(a:text, a:expr.'\s*$')
  if pos == -1
    return 0
  else
    if elixir#is_string_or_comment(a:lnum, pos)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the text matches the given expression
function! elixir#contains(text, expr)
  return a:text =~ a:expr
endfunction

" Returns 0 or 1 based on whether or not the given line number and column
" number pair is a string or comment
function! elixir#is_string_or_comment(line, col)
  call elixir#debug("is_string_or_comment - line=".a:line.", col=".a:col)
  call elixir#debug("rv = " . (synIDattr(synID(a:line, a:col, 1), "name") =~ '\%(String\|Comment\)'))
  return synIDattr(synID(a:line, a:col, 1), "name") =~ '\%(String\|Comment\)'
endfunction

" Skip expression for searchpair. Returns 0 or 1 based on whether the value
" under the cursor is a string or comment
function! elixir#searchpair_back_skip()
  " NOTE: @jbodah 2017-02-27: for some reason this function gets called with
  " and index that doesn't exist in the line sometimes. Detect and account for
  " that situation
  let curr_col = col('.')
  if getline('.')[curr_col-1] == ''
    let curr_col = curr_col-1
  endif
  return elixir#is_string_or_comment(line('.'), curr_col)
endfunction

" DRY up searchpair calls
function! elixir#searchpair_back(start, mid, end)
  let line = line('.')
  return searchpair(a:start, a:mid, a:end, 'bn', "line('.') == " . line . " || elixir#searchpair_back_skip()")
endfunction

" DRY up searchpairpos calls
function! elixir#searchpairpos_back(start, mid, end)
  let line = line('.')
  return searchpairpos(a:start, a:mid, a:end, 'bn', "line('.') == " . line . " || elixir#searchpair_back_skip()")
endfunction

" DRY up regex for keywords that 1) makes sure we only look at complete words
" and 2) ignores atoms
function! elixir#keyword(expr)
  return ':\@<!\<'.a:expr.'\>:\@!'
endfunction

" Start at the end of text and search backwards looking for a match. Also peek
" ahead if we get a match to make sure we get a complete match. This means
" that the result should be the position of the start of the right-most match
function! elixir#find_last_pos(lnum, text, match)
  let last = len(a:text) - 1
  let c = last

  while c >= 0
    let substr = strpart(a:text, c, last)
    let peek = strpart(a:text, c - 1, last)
    let ss_match = match(substr, a:match)
    if ss_match != -1
      let peek_match = match(peek, a:match)
      if peek_match == ss_match + 1
        let syng = synIDattr(synID(a:lnum, c + ss_match, 1), 'name')
        if syng !~ '\%(String\|Comment\)'
          return c + ss_match
        end
      end
    end
    let c -= 1
  endwhile

  return -1
endfunction

" Returns the indent level of the innermost data structure. For example, if we
" are in a list nested in a tuple then this function should return the indent
" level based on the list. Returns -1 if not in a data structure
function! elixir#find_innermost_block_indent(lnum)
  let innermost = -1

  " If in list...
  let pair_info = elixir#searchpairpos_back('\[', '', '\]')
  let pair_lnum = pair_info[0]
  let pair_col = pair_info[1]
  if pair_lnum != 0 || pair_col != 0
    let pair_text = getline(pair_lnum)
    let substr = strpart(pair_text, pair_col, len(pair_text)-1)
    let indent_pos = match(substr, '\S')
    if indent_pos != -1
      let innermost = max([innermost, indent_pos + pair_col])
    else
      let innermost = max([innermost, indent(pair_lnum) + 2])
    endif
  endif

  " TODO: @jbodah 2017-02-24: expand to be treated like []
  " If in tuple/map/struct...
  let pair_lnum = elixir#searchpair_back('{', '', '}')
  if pair_lnum
    echom "3"
    let innermost = max([innermost, indent(pair_lnum) + 2])
  endif

  return innermost
endfunction

" Main indent callback
function! elixir#indent(lnum)
  let lnum = a:lnum
  let text = getline(lnum)
  let prev_nb_lnum = prevnonblank(lnum-1)
  let prev_nb_text = getline(prev_nb_lnum)
  " TODO: @jbodah 2017-02-27: remove variable
  let prev_nb_indent = indent(prev_nb_lnum)

  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  call elixir#debug("Indenting line " . lnum)
  call elixir#debug("text = " . text)

  " 1. Look at last non-blank line...
  if prev_nb_lnum == 0
    call elixir#debug("top of file")
    return 0
  end

  if elixir#ends_with(prev_nb_text, elixir#keyword('do'), prev_nb_lnum)
    call elixir#debug("prev line ends with do")
    if elixir#starts_with(text, '\<end\>', lnum)
      return prev_nb_indent
    else
      return prev_nb_indent + 2
    end
  endif

  if elixir#ends_with(prev_nb_text, '\<else\>', prev_nb_lnum)
    call elixir#debug("prev line ends with else")
    return prev_nb_indent + 2
  endif

  if elixir#ends_with(prev_nb_text, binary_operator, prev_nb_lnum)
    call elixir#debug("prev line ends with binary operator")
    return prev_nb_indent + 2
  endif

  " 2. Look at current line...
  if elixir#starts_with(text, '|>', lnum)
    call elixir#debug("starts w pipe")
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#find_last_pos(prev_nb_lnum, prev_nb_text, match_operator)
    if pos == -1
      return indent(prev_nb_lnum)
    else
      let next_word_pos = match(strpart(prev_nb_text, pos+1, len(prev_nb_text)-1), '\S')
      if next_word_pos == -1
        return indent(prev_nb_lnum) + 2
      else
        return pos + 1 + next_word_pos
      end
    end
  endif

  if elixir#starts_with(text, '\<end\>', lnum)
    call elixir#debug("starts with end")
    let pair_lnum = elixir#searchpair_back(elixir#keyword('\%(do\|fn\)'), '', elixir#keyword('end').'\zs')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<else\>', lnum)
    call elixir#debug("starts with else")
    let pair_lnum = elixir#searchpair_back('\<if\>', '\<else\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<rescue\>', lnum)
    call elixir#debug("starts with rescue")
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<rescue\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<catch\>', lnum)
    call elixir#debug("starts with catch")
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<catch\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<after\>', lnum)
    call elixir#debug("starts with after")
    let pair_lnum = elixir#searchpair_back('\<receive\>', '\<after\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\]', lnum)
    call elixir#debug("starts with ]")
    let pair_lnum = elixir#searchpair_back('\[', '', '\]\zs')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '}', lnum)
    call elixir#debug("starts with }")
    let pair_lnum = elixir#searchpair_back('{', '', '}\zs')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, binary_operator, lnum)
    call elixir#debug("starts with binary operator")
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#find_last_pos(prev_nb_lnum, prev_nb_text, match_operator)
    if pos == -1
      echom "case1"
      return indent(prev_nb_lnum)
    else
      let next_word_pos = match(strpart(prev_nb_text, pos+1, len(prev_nb_text)-1), '\S')
      if next_word_pos == -1
        echom "case2"
        return indent(prev_nb_lnum) + 2
      else
        echom "case3"
        return pos + 1 + next_word_pos
      end
    end
  endif

  " 3. Nesting adjustments...
  " If in "cond" statement...
  let pair_lnum = elixir#searchpair_back('\<cond\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in cond")
    if elixir#contains(text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "case" statement...
  let pair_lnum = elixir#searchpair_back('\<case\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in case")
    if elixir#contains(text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "fn" statement...
  let pair_lnum = elixir#searchpair_back('\<fn\>', '', '\<end\>')
  if pair_lnum && pair_lnum != lnum
    call elixir#debug("in fn")
    if elixir#contains(text, '->')
      return indent(pair_lnum) + 2
    else
      if elixir#ends_with(prev_nb_text, '->', prev_nb_lnum)
        return prev_nb_indent + 2
      else
        return prev_nb_indent
      end
    end
  endif

  " If in "rescue" statement...
  let pair_lnum = elixir#searchpair_back('\<rescue\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in rescue")
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "catch" statement...
  let pair_lnum = elixir#searchpair_back('\<catch\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in catch")
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "after" statement...
  let pair_lnum = elixir#searchpair_back('\<after\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in after")
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "receive" statement...
  let pair_lnum = elixir#searchpair_back('\<receive\>', '', '\<\%(end\|after\)\>')
  if pair_lnum
    call elixir#debug("in receive")
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " Find innermost data structure and indent based on it...
  let block_indent = elixir#find_innermost_block_indent(lnum)
  if block_indent != -1
    call elixir#debug("found block indent")
    return block_indent
  endif

  " If in parens...
  call elixir#debug("checking parens"))
  let pair_lnum = elixir#searchpair_back('(', '', ')')
  if pair_lnum
    call elixir#debug("in parens")
    " Align indent (e.g. "def add(a,")
    let pos = elixir#find_last_pos(prev_nb_lnum, prev_nb_text, '\w\+,')
    if pos == -1
      return 0
    else
      return pos
    end
    return indent(pair_lnum) + 2
  endif

  " 4. Look back two non-blank lines...
  " If in a do-end block, use that as top-level
  let pair_lnum = searchpair(elixir#keyword('\%(do\|\fn\)'), '', elixir#keyword('end'), 'b', "line('.') == ".lnum." || elixir#is_string_or_comment(line('.'), col('.'))")
  if pair_lnum
    call elixir#debug("in do-end block as top-level")
    return indent(pair_lnum) + 2
  endif

  " 5. Else...
  call elixir#debug("defaulting")
  return 0
endfunction
