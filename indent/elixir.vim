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

function! elixir#handle_indent_top_of_file(_lnum, _text, prev_nb_lnum, _prev_nb_text)
  if a:prev_nb_lnum == 0
    call elixir#debug("top of file")
    return 0
  else
    return -1
  end
endfunction

function! elixir#handle_indent_following_trailing_do(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#ends_with(a:prev_nb_text, elixir#keyword('do'), a:prev_nb_lnum)
    call elixir#debug("prev line ends with do")
    if elixir#starts_with(a:text, '\<end\>', a:lnum)
      return indent(a:prev_nb_lnum)
    else
      return indent(a:prev_nb_lnum) + 2
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_following_trailing_else(_lnum, _text, prev_nb_lnum, prev_nb_text)
  if elixir#ends_with(a:prev_nb_text, '\<else\>', a:prev_nb_lnum)
    call elixir#debug("prev line ends with else")
    return indent(a:prev_nb_lnum) + 2
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_following_trailing_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if elixir#ends_with(a:prev_nb_text, binary_operator, a:prev_nb_lnum)
    call elixir#debug("prev line ends with binary operator")
    return indent(a:prev_nb_lnum) + 2
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_pipe(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#starts_with(a:text, '|>', a:lnum)
    call elixir#debug("starts w pipe")
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
    if pos == -1
      return indent(a:prev_nb_lnum)
    else
      let next_word_pos = match(strpart(a:prev_nb_text, pos+1, len(a:prev_nb_text)-1), '\S')
      if next_word_pos == -1
        return indent(a:prev_nb_lnum) + 2
      else
        return pos + 1 + next_word_pos
      end
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_end(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\<end\>', a:lnum)
    call elixir#debug("starts with end")
    let pair_lnum = elixir#searchpair_back(elixir#keyword('\%(do\|fn\)'), '', elixir#keyword('end').'\zs')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_else(lnum, text, prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\<else\>', a:lnum)
    call elixir#debug("starts with else")
    let pair_lnum = elixir#searchpair_back('\<if\>', '\<else\>\zs', '\<end\>')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_rescue(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\<rescue\>', a:lnum)
    call elixir#debug("starts with rescue")
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<rescue\>\zs', '\<end\>')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_catch(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\<catch\>', a:lnum)
    call elixir#debug("starts with catch")
    let pair_lnum = elixir#searchpair_back('\<try\>', '\<catch\>\zs', '\<end\>')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_after(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\<after\>', a:lnum)
    call elixir#debug("starts with after")
    let pair_lnum = elixir#searchpair_back('\<receive\>', '\<after\>\zs', '\<end\>')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_close_sq_bracket(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '\]', a:lnum)
    call elixir#debug("starts with ]")
    let pair_lnum = elixir#searchpair_back('\[', '', '\]\zs')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_close_curly_brace(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#starts_with(a:text, '}', a:lnum)
    call elixir#debug("starts with }")
    let pair_lnum = elixir#searchpair_back('{', '', '}\zs')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_starts_with_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if elixir#starts_with(a:text, binary_operator, a:lnum)
    call elixir#debug("starts with binary operator")
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
    if pos == -1
      return indent(a:prev_nb_lnum)
    else
      let next_word_pos = match(strpart(a:prev_nb_text, pos+1, len(a:prev_nb_text)-1), '\S')
      if next_word_pos == -1
        return indent(a:prev_nb_lnum) + 2
      else
        return pos + 1 + next_word_pos
      end
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_cond_block(_lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<cond\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in cond")
    if elixir#contains(a:text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_case_block(_lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<case\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in case")
    if elixir#contains(a:text, '->')
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_fn(lnum, text, prev_nb_lnum, prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<fn\>', '', '\<end\>')
  if pair_lnum && pair_lnum != a:lnum
    call elixir#debug("in fn")
    if elixir#contains(a:text, '->')
      return indent(pair_lnum) + 2
    else
      if elixir#ends_with(a:prev_nb_text, '->', a:prev_nb_lnum)
        return indent(a:prev_nb_lnum) + 2
      else
        return indent(a:prev_nb_lnum)
      end
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_rescue(lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<rescue\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in rescue")
    if elixir#ends_with(a:text, '->', a:lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_catch(lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<catch\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in catch")
    if elixir#ends_with(a:text, '->', a:lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_after(lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<after\>', '', '\<end\>')
  if pair_lnum
    call elixir#debug("in after")
    if elixir#ends_with(a:text, '->', a:lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_receive(lnum, text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = elixir#searchpair_back('\<receive\>', '', '\<\%(end\|after\)\>')
  if pair_lnum
    call elixir#debug("in receive")
    if elixir#ends_with(a:text, '->', a:lnum)
      return indent(pair_lnum) + 2
    else
      return indent(pair_lnum) + 4
    end
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_data_structure(_lnum, _text, _prev_nb_lnum, _prev_nb_text)
  let innermost = -1

  " If in list...
  let pair_info = elixir#searchpairpos_back('\[', '', '\]')
  let pair_lnum = pair_info[0]
  let pair_col = pair_info[1]
  if pair_lnum != 0 || pair_col != 0
    call elixir#debug("in list")
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
    call elixir#debug("in tuple/map/struct")
    let innermost = max([innermost, indent(pair_lnum) + 2])
  endif

  return innermost
endfunction

function! elixir#handle_indent_inside_parens(_lnum, _text, prev_nb_lnum, prev_nb_text)
  call elixir#debug("checking parens"))
  let pair_lnum = elixir#searchpair_back('(', '', ')')
  if pair_lnum
    call elixir#debug("in parens")
    " Align indent (e.g. "def add(a,")
    let pos = elixir#find_last_pos(a:prev_nb_lnum, a:prev_nb_text, '\w\+,')
    if pos == -1
      return 0
    else
      return pos
    end
    return indent(pair_lnum) + 2
  else
    return -1
  endif
endfunction

function! elixir#handle_indent_inside_generic_block(lnum, _text, _prev_nb_lnum, _prev_nb_text)
  let pair_lnum = searchpair(elixir#keyword('\%(do\|\fn\)'), '', elixir#keyword('end'), 'b', "line('.') == ".a:lnum." || elixir#is_string_or_comment(line('.'), col('.'))")
  if pair_lnum
    call elixir#debug("in do-end block as top-level")
    return indent(pair_lnum) + 2
  else
    return -1
  endif
endfunction

" Main indent callback
function! elixir#indent(lnum)
  let lnum = a:lnum
  let text = getline(lnum)
  let prev_nb_lnum = prevnonblank(lnum-1)
  let prev_nb_text = getline(prev_nb_lnum)

  call elixir#debug("Indenting line " . lnum)
  call elixir#debug("text = " . text)

  " 1. Look at last non-blank line...
  let handlers = [
        \'top_of_file',
        \'following_trailing_do',
        \'following_trailing_else',
        \'following_trailing_binary_operator',
        \'starts_with_pipe',
        \'starts_with_end',
        \'starts_with_else',
        \'starts_with_rescue',
        \'starts_with_catch',
        \'starts_with_after',
        \'starts_with_close_sq_bracket',
        \'starts_with_close_curly_brace',
        \'starts_with_binary_operator',
        \'inside_cond_block',
        \'inside_case_block',
        \'inside_fn',
        \'inside_rescue',
        \'inside_catch',
        \'inside_after',
        \'inside_receive',
        \'inside_data_structure',
        \'inside_parens',
        \'inside_generic_block'
        \]
  for handler in handlers
    let indent = function('elixir#handle_indent_'.handler)(lnum, text, prev_nb_lnum, prev_nb_text)
    if indent != -1
      return indent
    endif
  endfor

  call elixir#debug("defaulting")
  return 0
endfunction
