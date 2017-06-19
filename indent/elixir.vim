if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal indentexpr=elixir#indent(v:lnum)

setlocal indentkeys+=0=end,0=catch,0=rescue,0=after,0=else,0=do,*<Return>,=->,0},0],0),0=\|>,0=<>
" TODO: @jbodah 2017-02-27: all operators should cause reindent when typed

function! elixir#indent(lnum)
  let lnum = a:lnum
  let text = getline(lnum)
  let prev_nb_lnum = prevnonblank(lnum-1)
  let prev_nb_text = getline(prev_nb_lnum)

  call elixir#indent#debug("==> Indenting line " . lnum)
  call elixir#indent#debug("text = '" . text . "'")

  let handlers = [
        \'top_of_file',
        \'pattern_match_case',
        \'starts_with_end',
        \'starts_with_mid_or_end_block_keyword',
        \'following_trailing_keyword',
        \'following_trailing_arrow',
        \'following_trailing_end',
        \'following_trailing_open_data_structure',
        \'following_trailing_open_parens',
        \'following_trailing_binary_operator',
        \'starts_with_pipe',
        \'starts_with_close_bracket',
        \'starts_with_binary_operator',
        \'starts_with_comment',
        \'inside_parens',
        \'follow_last_line'
        \]
        " \'inside_generic_block',
        " \'inside_nested_construct',
  for handler in handlers
    call elixir#indent#debug('testing handler elixir#indent#handle_'.handler)
    let indent = function('elixir#indent#handle_'.handler)(lnum, text, prev_nb_lnum, prev_nb_text)
    if indent != -1
      call elixir#indent#debug('line '.lnum.': elixir#indent#handle_'.handler.' returned '.indent)
      return indent
    endif
  endfor

  call elixir#indent#debug("defaulting")
  return indent(prev_nb_lnum)
endfunction
