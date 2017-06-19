function! elixir#indent#debug(str)
  if exists("g:elixir_indent_debug") && g:elixir_indent_debug
    echom a:str
  endif
endfunction

" Returns 0 or 1 based on whether or not the text starts with the given
" expression and is not a string or comment
function! elixir#indent#starts_with(text, expr, lnum)
  let pos = match(a:text, '^\s*'.a:expr)
  if pos == -1
    return 0
  else
    " NOTE: @jbodah 2017-02-24: pos is the index of the match which is
    " zero-indexed. Add one to make it the column number
    if elixir#indent#is_string_or_comment(a:lnum, pos + 1)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the text ends with the given
" expression and is not a string or comment
function! elixir#indent#ends_with(text, expr, lnum)
  let pos = match(a:text, a:expr.'\s*$')
  if pos == -1
    return 0
  else
    if elixir#indent#is_string_or_comment(a:lnum, pos)
      return 0
    else
      return 1
    end
  end
endfunction

" Returns 0 or 1 based on whether or not the text matches the given expression
function! elixir#indent#contains(text, expr)
  return a:text =~ a:expr
endfunction

" Returns 0 or 1 based on whether or not the given line number and column
" number pair is a string or comment
function! elixir#indent#is_string_or_comment(line, col)
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
  return elixir#indent#is_string_or_comment(line('.'), curr_col)
endfunction

" DRY up searchpair calls
function! elixir#indent#searchpair_back(start, mid, end)
  let line = line('.')
  return searchpair(a:start, a:mid, a:end, 'bnW', "line('.') == " . line . " || elixir#indent#searchpair_back_skip()")
endfunction

" DRY up searchpairpos calls
function! elixir#indent#searchpairpos_back(start, mid, end)
  let line = line('.')
  return searchpairpos(a:start, a:mid, a:end, 'bnW', "line('.') == " . line . " || elixir#indent#searchpair_back_skip()")
endfunction

" DRY up regex for keywords that 1) makes sure we only look at complete words
" and 2) ignores atoms
function! elixir#indent#keyword(expr)
  return ':\@<!\<\C\%('.a:expr.'\)\>:\@!'
endfunction

function! elixir#indent#starts_with_comment(text)
  return match(a:text, '^\s*#') != -1
endfunction

" Start at the end of text and search backwards looking for a match. Also peek
" ahead if we get a match to make sure we get a complete match. This means
" that the result should be the position of the start of the right-most match
function! elixir#indent#find_last_pos(lnum, text, match)
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

function! elixir#indent#handle_following_trailing_keyword(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#ends_with(a:prev_nb_text, elixir#indent#keyword('do\|catch\|rescue\|after\|else'), a:prev_nb_lnum)
    if elixir#indent#starts_with(a:text, elixir#indent#keyword('end'), a:lnum)
      return indent(a:prev_nb_lnum)
    else
      return indent(a:prev_nb_lnum) + &sw
    end
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_pattern_match_case(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#contains(a:text, '->')
    " NOTE: @jbodah 2017-06-16: there's something bizarre going on where this
    " only moves the cursor if I save this result...
    let searchres = search('->', '', line('.'))
    let block_start_info = searchpairpos('\%(cond\|case\|fn\|receive\|catch\|rescue\|else\)', '', 'end', 'b')
    let block_start_line = block_start_info[0]
    call elixir#indent#debug(string(block_start_info))
    if block_start_line == a:lnum
      " Ignore inline functions
      return -1
    else
      " This line indents fn/case matches to be inline with fn/case
      " let block_start_indent = block_start_info[1] - 1
      " return block_start_indent + &sw
      return indent(block_start_line) + &sw
    end
  else
    return -1
  endfunction
endfunction

function! elixir#indent#handle_following_trailing_arrow(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#ends_with(a:prev_nb_text, '->', a:prev_nb_lnum)
    return indent(a:prev_nb_lnum) + &sw
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_trailing_open_data_structure(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#ends_with(a:prev_nb_text, '\%({\|[\)', a:prev_nb_lnum)
    if elixir#indent#starts_with(a:text, '\%(}\|]\)', a:lnum)
      return indent(a:prev_nb_lnum)
    else
      return indent(a:prev_nb_lnum) + &sw
    endif
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_trailing_open_parens(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#ends_with(a:prev_nb_text, '(', a:prev_nb_lnum)
    if elixir#indent#starts_with(a:text, ')', a:lnum)
      return indent(a:prev_nb_lnum)
    else
      return indent(a:prev_nb_lnum) + &sw
    endif
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_trailing_end(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#ends_with(a:prev_nb_text, elixir#indent#keyword('end'), a:prev_nb_lnum)
    return indent(a:prev_nb_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_following_trailing_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if elixir#indent#ends_with(a:prev_nb_text, binary_operator, a:prev_nb_lnum)
    return indent(a:prev_nb_lnum) + &sw
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_pipe(lnum, text, prev_nb_lnum, prev_nb_text)
  if elixir#indent#starts_with(a:text, '|>', a:lnum)
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#indent#find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
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
  if elixir#indent#starts_with_comment(a:text)
    return indent(a:prev_nb_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_end(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#indent#starts_with(a:text, elixir#indent#keyword('end'), a:lnum)
    let pair_lnum = elixir#indent#searchpair_back(elixir#indent#keyword('do\|fn'), '', elixir#indent#keyword('end').'\zs')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_mid_or_end_block_keyword(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#indent#starts_with(a:text, elixir#indent#keyword('catch\|rescue\|after\|else'), a:lnum)
    let pair_lnum = elixir#indent#searchpair_back(elixir#indent#keyword('with\|receive\|try\|if\|fn'), elixir#indent#keyword('catch\|rescue\|after\|else').'\zs', elixir#indent#keyword('end'))
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_close_bracket(lnum, text, _prev_nb_lnum, _prev_nb_text)
  if elixir#indent#starts_with(a:text, '\%(\]\|}\|)\)', a:lnum)
    let pair_lnum = elixir#indent#searchpair_back('\%(\[\|{\|(\)', '', '\%(\]\|}\|)\)')
    return indent(pair_lnum)
  else
    return -1
  endif
endfunction

function! elixir#indent#handle_starts_with_binary_operator(lnum, text, prev_nb_lnum, prev_nb_text)
  let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

  if elixir#indent#starts_with(a:text, binary_operator, a:lnum)
    let match_operator = '\%(!\|=\|<\|>\)\@<!=\%(=\|>\|\~\)\@!'
    let pos = elixir#indent#find_last_pos(a:prev_nb_lnum, a:prev_nb_text, match_operator)
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

function! elixir#indent#traverse_blocks(lnum, text)
  " Split the previous line and check to see our block depth
  let stack = []
  let stack_depth = 0

  let curr_lnum = a:lnum
  let curr_text = a:text

  while curr_lnum > 0
    let chars = split(curr_text, '.\zs')
    let char_idx = len(chars) - 1

    while char_idx >= 0
      let char = chars[char_idx]
      if char == ' '
        " do nothing
      elseif char =~ '[])}]'
        let stack += [char]
        let stack_depth += 1
      elseif char =~ '[[({]'
        " TODO: @jbodah 2017-06-19: this is soooo slowww
        if elixir#indent#is_string_or_comment(curr_lnum, char_idx)
          " do nothing
        else
          if stack[-1] =~ '[])}]'
            let stack = stack[0:-2]
          endif

          let stack_depth -= 1

          if stack_depth == -1
            let last_char_idx = char_idx + 1 + elixir#indent#find_idx_of_first_nonspace(strpart(curr_text, char_idx + 1))
          end
        endif
      endif

      let char_idx -= 1
    endwhile

    if stack_depth == 0
      return [curr_lnum, indent(curr_lnum)]
    elseif stack_depth < 0
      return [curr_lnum, last_char_idx]
    endif

    let curr_lnum = curr_lnum - 1
    let curr_text = getline(curr_lnum)
  endwhile

  return -1
endfunction

function! elixir#indent#find_idx_of_first_nonspace(string)
  let chars = split(a:string, '.\zs')
  let idx = 0
  for c in chars
    if c != ' '
      return idx
    else
      let idx += 1
    endif
  endfor
endfunction

function! elixir#indent#handle_follow_last_line(curr_lnum, curr_text, candidate_lnum, candidate_text)
  " 0. recursion base case
  if a:candidate_lnum <= 0
    return -1
  endif

  " 1. check if we should skip the candidate
  if elixir#indent#should_skip_line(a:candidate_lnum, a:candidate_text)
    " try next line
    let new_line = prevnonblank(a:candidate_lnum - 1)
    let new_text = getline(new_line)
    return elixir#indent#handle_follow_last_line(a:curr_lnum, a:curr_text, new_line, new_text)
  endif

  " 2. check for any blocks the candidate might be nested in
  let new_pos = elixir#indent#traverse_blocks(a:candidate_lnum, a:candidate_text)
  let new_lnum = new_pos[0]
  let indent = new_pos[1]

  " 3. did we find a block? was it on a different line? are we supposed to be
  " skipping that line?
  if new_lnum != a:candidate_lnum && elixir#indent#should_skip_line(new_lnum, getline(new_lnum))
    let new_line = prevnonblank(new_lnum - 1)
    let new_text = getline(new_line)
    return elixir#indent#handle_follow_last_line(a:curr_lnum, a:curr_text, new_line, new_text)
  else
    return indent
  endif
endfunction

function! elixir#indent#should_skip_line(candidate_lnum, candidate_text)
    let binary_operator = '\%(=\|<>\|>>>\|<=\|||\|+\|\~\~\~\|-\|&&\|<<<\|/\|\^\^\^\|\*\)'

    if elixir#indent#starts_with(a:candidate_text, binary_operator, a:candidate_lnum)
      return 1
    endif

    if elixir#indent#starts_with(a:candidate_text, '|>', a:candidate_lnum)
      return 1
    endif

    let lookahead_lnum = prevnonblank(a:candidate_lnum - 1)
    let lookahead_text = getline(lookahead_lnum)

    if elixir#indent#ends_with(lookahead_text, binary_operator, lookahead_lnum)
      return 1
    endif

    return 0
endfunction
