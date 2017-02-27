" " Only load this indent file when no other was loaded
" if exists("b:did_indent") || exists("*elixir#indent")
"   finish
" end
" let b:did_indent = 1

setlocal indentexpr=elixir#indent(v:lnum)

setlocal indentkeys+=0=end,0=catch,0=rescue,0=after,0=else,=->,0},0],0=\|>
" setlocal indentkeys+=0)

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

function! elixir#contains(text, expr)
  return a:text =~ a:expr
endfunction

function! elixir#is_string_or_comment(line, pos)
  echom "is_string_or_comment - line=".a:line.", pos=".a:pos
  echom "rv = " . (synIDattr(synID(a:line, a:pos, 1), "name") =~ '\%(String\|Comment\)')
  return synIDattr(synID(a:line, a:pos, 1), "name") =~ '\%(String\|Comment\)'
endfunction

function! elixir#searchpair_back_skip()
  let curr_col = col('.')
  if getline('.')[curr_col-1] == ''
    let curr_col = curr_col-1
  endif
  return elixir#is_string_or_comment(line('.'), curr_col)
endfunction

function! elixir#searchpair_back(start, mid, end)
  return searchpair(a:start, a:mid, a:end, 'bn', "elixir#searchpair_back_skip()")
endfunction

function! elixir#searchpairpos_back(start, mid, end)
  return searchpairpos(a:start, a:mid, a:end, 'bn', "elixir#searchpair_back_skip()")
endfunction

function! elixir#keyword(expr)
  return ':\@<!\<'.a:expr.'\>:\@!'
endfunction

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

  " TODO: @jbodah 2017-02-24:
  " If in tuple/map/struct...
  let pair_lnum = elixir#searchpair_back('{', '', '}')
  if pair_lnum
    let innermost = max([innermost, indent(pair_lnum) + 2])
  endif

  return innermost
endfunction

function! elixir#indent(lnum)
  let lnum = a:lnum
  let text = getline(lnum)
  let prev_nb_lnum = prevnonblank(lnum-1)
  let prev_nb_text = getline(prev_nb_lnum)
  let prev_nb_indent = indent(prev_nb_lnum)
  let two_prev_nb_lnum = prevnonblank(prev_nb_lnum-1)
  let two_prev_nb_text = getline(two_prev_nb_lnum)
  let two_prev_nb_indent = indent(two_prev_nb_lnum)

  let searchpair_skip = "synIDattr(synID(line('.'), col('.'), 1), 'name') =~ '\\%(String\\|Comment\\)'"
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  echom "Indenting line " . lnum
  echom "text = " . text

  " 1. Look at last non-blank line...
  if prev_nb_lnum == 0
    echom "top of file"
    return 0
  end

  if elixir#ends_with(prev_nb_text, elixir#keyword('do'), prev_nb_lnum)
    echom "prev line ends with do"
    if elixir#starts_with(text, '\<end\>', lnum)
      return prev_nb_indent
    else
      return prev_nb_indent + 2
    end
  endif

  if elixir#ends_with(prev_nb_text, '\<else\>', prev_nb_lnum)
    echom "prev line ends with else"
    return prev_nb_indent + 2
  endif

  if elixir#ends_with(prev_nb_text, binary_operator, prev_nb_lnum)
    echom "prev line ends with binary operator"
    return prev_nb_indent + 2
  endif

  " 2. Look at current line...
  if elixir#starts_with(text, '|>', lnum)
    echom "starts w pipe"
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#find_last_pos(prev_nb_lnum, prev_nb_text, match_operator)
    if pos == -1
      return indent(prev_nb_lnum)
    else
      let next_word_pos = match(strpart(prev_nb_text, pos+1, len(text)-1), '\S')
      if next_word_pos == -1
        return indent(prev_nb_lnum) + 2
      else
        return pos + 1 + next_word_pos
      end
    end
  endif

  if elixir#starts_with(text, '\<end\>', lnum)
    echom "starts with end"
    let pair_lnum = elixir#searchpair_back(elixir#keyword('\%(do\|fn\)'), '', elixir#keyword('end').'\zs')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<else\>', lnum)
    echom "starts with else"
    let pair_lnum = elixir#searchpair_back('\<if\>', '\<else\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<rescue\>', lnum)
    echom "starts with rescue"
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<rescue\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<catch\>', lnum)
    echom "starts with catch"
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<catch\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\<after\>', lnum)
    echom "starts with after"
    let pair_lnum = elixir#searchpair_back('\<receive\>', '\<after\>\zs', '\<end\>')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '\]', lnum)
    echom "starts with ]"
    let pair_lnum = elixir#searchpair_back('\[', '', '\]\zs')
    return indent(pair_lnum)
  endif

  if elixir#starts_with(text, '}', lnum)
    echom "starts with }"
    let pair_lnum = elixir#searchpair_back('{', '', '}\zs')
    return indent(pair_lnum)
  endif

  " 3. Nesting adjustments...
  " If in "cond" statement...
  let pair_lnum = elixir#searchpair_back('\<cond\>', '', '\<end\>')
  if pair_lnum
    echom "in cond"
    if elixir#contains(text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "case" statement...
  let pair_lnum = elixir#searchpair_back('\<case\>', '', '\<end\>')
  if pair_lnum
    echom "in case"
    if elixir#contains(text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "fn" statement...
  let pair_lnum = elixir#searchpair_back('\<fn\>', '', '\<end\>')
  if pair_lnum && pair_lnum != lnum
    echom "in fn"
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
    echom "in rescue"
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "catch" statement...
  let pair_lnum = elixir#searchpair_back('\<catch\>', '', '\<end\>')
  if pair_lnum
    echom "in catch"
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "after" statement...
  let pair_lnum = elixir#searchpair_back('\<after\>', '', '\<end\>')
  if pair_lnum
    echom "in after"
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " If in "receive" statement...
  let pair_lnum = elixir#searchpair_back('\<receive\>', '', '\<\%(end\|after\)\>')
  if pair_lnum
    echom "in receive"
    if elixir#ends_with(text, '->', lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  endif

  " Find innermost data structure and indent based on it...
  let block_indent = elixir#find_innermost_block_indent(lnum)
  if block_indent != -1
    echom "found block indent"
    return block_indent
  endif

  " If in parens...
  echom "checking parens"
  let pair_lnum = elixir#searchpair_back('(', '', ')')
  if pair_lnum
    echom "in parens"
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
  " if elixir#ends_with(two_prev_nb_text, binary_operator, two_prev_nb_lnum)
  "   return two_prev_nb_indent
  " end

  " If in a do-end block, use that as top-level
  let pair_lnum = searchpair(elixir#keyword('\%(do\|\fn\)'), '', elixir#keyword('end'), 'b', "line('.') == ".lnum." || elixir#is_string_or_comment(line('.'), col('.'))")
  if pair_lnum
    echom "in do-end block as top-level"
    return indent(pair_lnum) + 2
  endif

  echom "defaulting"
  " Else...
  return 0
endfunction
