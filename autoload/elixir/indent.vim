if !exists("g:elixir_indent_max_lookbehind")
  let g:elixir_indent_max_lookbehind = 30
endif

function! elixir#indent#indent(lnum)
  let lnum = a:lnum
  let text = getline(lnum)
  let prev_nb_lnum = prevnonblank(lnum-1)
  let prev_nb_text = getline(prev_nb_lnum)

  call s:debug("==> Indenting line " . lnum)
  call s:debug("text = '" . text . "'")

  let handlers = [
        \'top_of_file',
        \'starts_with_end',
        \'starts_with_mid_or_end_block_keyword',
        \'following_trailing_do',
        \'following_trailing_binary_operator',
        \'starts_with_pipe',
        \'starts_with_close_bracket',
        \'starts_with_binary_operator',
        \'inside_nested_construct',
        \'starts_with_comment',
        \'inside_generic_block',
        \'following_prev_end'
        \]
  for handler in handlers
    call s:debug('testing handler elixir#indent#handle_'.handler)
    let indent = function('elixir#indent#handle_'.handler)(lnum, text, prev_nb_lnum, prev_nb_text)
    if indent != -1
      call s:debug('line '.lnum.': elixir#indent#handle_'.handler.' returned '.indent)
      return indent
    endif
  endfor

  call s:debug("defaulting")
  return 0
endfunction

function! s:debug(str)
  if exists("g:elixir_indent_debug") && g:elixir_indent_debug
    echom a:str
  endif
endfunction

" Returns 0 or 1 based on whether or not the text starts with the given
" expression and is not a string or comment
function! s:starts_with(text, expr, lnum)
  let pos = match(a:text, '^\s*'.a:expr)
  if pos == -1
    return 0
  else
    " NOTE: @jbodah 2017-02-24: pos is the index of the match which is
    " zero-indexed. Add one to make it the column number
    if s:is_string_or_comment(a:lnum, pos + 1)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the text ends with the given
" expression and is not a string or comment
function! s:ends_with(text, expr, lnum)
  let pos = match(a:text, a:expr.'\s*$')
  if pos == -1
    return 0
  else
    if s:is_string_or_comment(a:lnum, pos)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the given line number and column
" number pair is a string or comment
function! s:is_string_or_comment(line, col)
  return synIDattr(synID(a:line, a:col, 1), "name") =~ '\%(String\|Comment\)'
endfunction

" Skip expression for searchpair. Returns 0 or 1 based on whether the value
" under the cursor is a string or comment
function! elixir#indent#searchpair_back_skip()
  " NOTE: @jbodah 2017-02-27: for some reason this function gets called with
  " and index that doesn't exist in the line sometimes. Detect and account for
  " that situation
  let curr_col = col('.')
  if getline('.')[curr_col-1] == ''
    let curr_col = curr_col-1
  endif
  return s:is_string_or_comment(line('.'), curr_col)
endfunction

" DRY up regex for keywords that 1) makes sure we only look at complete words
" and 2) ignores atoms
function! s:keyword(expr)
  return ':\@<!\<\C\%('.a:expr.'\)\>:\@!'
endfunction

" Start at the end of text and search backwards looking for a match. Also peek
" ahead if we get a match to make sure we get a complete match. This means
" that the result should be the position of the start of the right-most match
function! s:find_last_pos(lnum, text, match)
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

function! elixir#indent#handle_top_of_file(_lnum, _text, prev_nb_lnum, _prev_nb_text)
  if a:prev_nb_lnum == 0
    return 0
  else
    return -1
  end
endfunction

" TODO: @jbodah 2017-03-31: remove
function! elixir#indent#handle_following_trailing_do(lnum, text, prev_nb_lnum, prev_nb_text)
  if s:ends_with(a:prev_nb_text, s:keyword('do'), a:prev_nb_lnum)
    if s:starts_with(a:text, s:keyword('end'), a:lnum)
      return indent(a:prev_nb_lnum)
    else
      return indent(a:prev_nb_lnum) + &sw
    end
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_trailing_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if s:ends_with(a:prev_nb_text, binary_operator, a:prev_nb_lnum)
    return indent(a:prev_nb_lnum) + &sw
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_prev_end(_lnum, _text, prev_nb_lnum, prev_nb_text)
  if s:ends_with(a:prev_nb_text, s:keyword('end'), a:prev_nb_lnum)
    return indent(a:prev_nb_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_pipe(lnum, text, prev_nb_lnum, prev_nb_text)
  if s:starts_with(a:text, '|>', a:lnum)
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = s:find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
    if pos == -1
      return indent(a:prev_nb_lnum)
    else
      let next_word_pos = match(strpart(a:prev_nb_text, pos+1, len(a:prev_nb_text)-1), '\S')
      if next_word_pos == -1
        return indent(a:prev_nb_lnum) + &sw
      else
        return pos + 1 + next_word_pos
      end
    end
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_comment(_lnum, text, prev_nb_lnum, _prev_nb_text)
  if match(a:text, '^\s*#') != -1
    return indent(a:prev_nb_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_end(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if s:starts_with(a:text, s:keyword('end'), a:lnum)
    let pair_lnum = searchpair(s:keyword('do\|fn'), '', s:keyword('end').'\zs', 'bnW', "line('.') == " . line('.') . " || elixir#indent#searchpair_back_skip()")
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_mid_or_end_block_keyword(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if s:starts_with(a:text, s:keyword('catch\|rescue\|after\|else'), a:lnum)
    let pair_lnum = searchpair(s:keyword('with\|receive\|try\|if\|fn'), s:keyword('catch\|rescue\|after\|else').'\zs', s:keyword('end'), 'bnW', "line('.') == " . line('.') . " || elixir#indent#searchpair_back_skip()")
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_close_bracket(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if s:starts_with(a:text, '\%(\]\|}\|)\)', a:lnum)
    let pair_lnum = searchpair('\%(\[\|{\|(\)', '', '\%(\]\|}\|)\)', 'bnW', "line('.') == " . line('.') . " || elixir#indent#searchpair_back_skip()")
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if s:starts_with(a:text, binary_operator, a:lnum)
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = s:find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
    if pos == -1
      return indent(a:prev_nb_lnum)
    else
      let next_word_pos = match(strpart(a:prev_nb_text, pos+1, len(a:prev_nb_text)-1), '\S')
      if next_word_pos == -1
        return indent(a:prev_nb_lnum) + &sw
      else
        return pos + 1 + next_word_pos
      end
    end
  else
    return -1
  endif
endfunction

" To handle nested structures properly we need to find the innermost
" nested structure. For example, we might be in a function in a map in a
" function, etc... so we need to first figure out what the innermost structure
" is then forward execution to the proper handler
function! elixir#indent#handle_inside_nested_construct(lnum, text, prev_nb_lnum, prev_nb_text)
  let start_pattern = '\C\%(\<with\>\|\<if\>\|\<case\>\|\<cond\>\|\<try\>\|\<receive\>\|\<fn\>\|{\|\[\|(\)'
  let end_pattern = '\C\%(\<end\>\|\]\|}\|)\)'
  let pair_info = searchpairpos(start_pattern, '', end_pattern, 'bnW', "line('.') == " . line('.') . " || elixir#indent#searchpair_back_skip()", max([0, a:lnum - g:elixir_indent_max_lookbehind]))
  let pair_lnum = pair_info[0]
  let pair_col = pair_info[1]
  if pair_lnum != 0 || pair_col != 0
    let pair_text = getline(pair_lnum)
    let pair_char = pair_text[pair_col - 1]
    if pair_char == 'f'
      call s:debug("testing s:do_handle_inside_fn")
      return s:do_handle_inside_fn(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    elseif pair_char == '['
      call s:debug("testing s:do_handle_inside_square_brace")
      return s:do_handle_inside_square_brace(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    elseif pair_char == '{'
      call s:debug("testing s:do_handle_inside_curly_brace")
      return s:do_handle_inside_curly_brace(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    elseif pair_char == '('
      call s:debug("testing s:do_handle_inside_parens")
      return s:do_handle_inside_parens(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    elseif pair_char == 'w'
      call s:debug("testing s:do_handle_inside_with")
      return s:do_handle_inside_with(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    else
      call s:debug("testing s:do_handle_inside_keyword_block")
      return s:do_handle_inside_keyword_block(pair_lnum, pair_col, a:lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    end
  else
    return -1
  end
endfunction

function! s:do_handle_inside_with(pair_lnum, pair_col, lnum, text, prev_nb_lnum, prev_nb_text)
  if a:pair_lnum == a:lnum
    " This is the `with` line or an inline `with`/`do`
    call s:debug("current line is `with`")
    return -1
  else
    " Determine if in with/do, do/else|end, or else/end
    let start_pattern = '\C\%(\<with\>\|\<else\>\|\<do\>\)'
    let end_pattern = '\C\%(\<end\>\)'
    let pair_info = searchpairpos(start_pattern, '', end_pattern, 'bnW', "line('.') == " . line('.') . " || elixir#indent#searchpair_back_skip()")
    let pair_lnum = pair_info[0]
    let pair_col = pair_info[1]

    let pair_text = getline(pair_lnum)
    let pair_char = pair_text[pair_col - 1]

    if s:starts_with(a:text, '\Cdo:', a:lnum)
      call s:debug("current line is do:")
      return pair_col - 1 + &sw
    elseif s:starts_with(a:text, '\Celse:', a:lnum)
      call s:debug("current line is else:")
      return pair_col - 1
    elseif s:starts_with(a:text, '\C\(\<do\>\|\<else\>\)', a:lnum)
      call s:debug("current line is do/else")
      return pair_col - 1
    elseif s:starts_with(pair_text, '\C\(do\|else\):', pair_lnum)
      call s:debug("inside do:/else:")
      return pair_col - 1 + &sw
    elseif pair_char == 'w'
      call s:debug("inside with/do")
      return pair_col + 4
    elseif pair_char == 'd'
      call s:debug("inside do/else|end")
      return pair_col - 1 + &sw
    else
      call s:debug("inside else/end")
      return s:do_handle_inside_pattern_match_block(pair_lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    end
  end
endfunction

function! s:do_handle_inside_keyword_block(pair_lnum, _pair_col, _lnum, text, prev_nb_lnum, prev_nb_text)
  let keyword_pattern = '\C\%(\<case\>\|\<cond\>\|\<try\>\|\<receive\>\|\<after\>\|\<catch\>\|\<rescue\>\|\<else\>\)'
  if a:pair_lnum
    " last line is a "receive" or something
    if s:starts_with(a:prev_nb_text, keyword_pattern, a:prev_nb_lnum)
      call s:debug("prev nb line is keyword")
      return indent(a:prev_nb_lnum) + &sw
    else
      return s:do_handle_inside_pattern_match_block(a:pair_lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
    end
  else
    return -1
  endif
endfunction

" Implements indent for pattern-matching blocks (e.g. case, fn, with/else)
function! s:do_handle_inside_pattern_match_block(block_start_lnum, text, prev_nb_lnum, prev_nb_text)
  if a:text =~ '->'
    call s:debug("current line contains ->")
    return indent(a:block_start_lnum) + &sw
  elseif a:prev_nb_text =~ '->'
    call s:debug("prev nb line contains ->")
    return indent(a:prev_nb_lnum) + &sw
  else
    return indent(a:prev_nb_lnum)
  end
endfunction

function! s:do_handle_inside_fn(pair_lnum, _pair_col, lnum, text, prev_nb_lnum, prev_nb_text)
  if a:pair_lnum && a:pair_lnum != a:lnum
    return s:do_handle_inside_pattern_match_block(a:pair_lnum, a:text, a:prev_nb_lnum, a:prev_nb_text)
  else
    return -1
  endif
endfunction

function! s:do_handle_inside_square_brace(pair_lnum, pair_col, _lnum, _text, _prev_nb_lnum, _prev_nb_text)
  " If in list...
  if a:pair_lnum != 0 || a:pair_col != 0
    let pair_text = getline(a:pair_lnum)
    let substr = strpart(pair_text, a:pair_col, len(pair_text)-1)
    let indent_pos = match(substr, '\S')
    if indent_pos != -1
      return indent_pos + a:pair_col
    else
      return indent(a:pair_lnum) + &sw
    endif
  else
    return -1
  end
endfunction

function! s:do_handle_inside_curly_brace(pair_lnum, _pair_col, _lnum, _text, _prev_nb_lnum, _prev_nb_text)
  return indent(a:pair_lnum) + &sw
endfunction

function! s:do_handle_inside_parens(pair_lnum, pair_col, _lnum, _text, prev_nb_lnum, prev_nb_text)
  if a:pair_lnum
    if s:ends_with(a:prev_nb_text, '(', a:prev_nb_lnum)
      return indent(a:prev_nb_lnum) + &sw
    elseif a:pair_lnum == a:prev_nb_lnum
      " Align indent (e.g. "def add(a,")
      let pos = s:find_last_pos(a:prev_nb_lnum, a:prev_nb_text, '[^(]\+,')
      if pos == -1
        return 0
      else
        return pos
      end
    else
      return indent(a:prev_nb_lnum)
    end
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_inside_generic_block(lnum, _text, prev_nb_lnum, prev_nb_text)
  let pair_lnum = searchpair(s:keyword('do\|fn'), '', s:keyword('end'), 'bW', "line('.') == ".a:lnum." || s:is_string_or_comment(line('.'), col('.'))", max([0, a:lnum - g:elixir_indent_max_lookbehind]))
  if pair_lnum
    " TODO: @jbodah 2017-03-29: this should probably be the case in *all*
    " blocks
    if s:ends_with(a:prev_nb_text, ',', a:prev_nb_lnum)
      return indent(pair_lnum) + 2 * &sw
    else
      return indent(pair_lnum) + &sw
    endif
  else
    return -1
  endif
endfunction
