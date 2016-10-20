if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal nosmartindent

setlocal indentexpr=GetElixirIndent()
setlocal indentkeys+=0),0],0=end,0=else,0=match,0=elsif,0=catch,0=after,0=rescue,0=\|>,=->

if exists("*GetElixirIndent")
  finish
end

let s:cpo_save = &cpo
set cpo&vim

let s:no_colon_before = ':\@<!'
let s:no_colon_after = ':\@!'
let s:ending_symbols = '\]\|}\|)'
let s:starting_symbols = '\[\|{\|('
let s:arrow = '->'
let s:end_with_arrow = s:arrow.'$'
let s:skip_syntax = '\%(Comment\|String\)$'
let s:block_skip = "synIDattr(synID(line('.'),col('.'),1),'name') =~? '".s:skip_syntax."'"
let s:fn = '\<fn\>'
let s:multiline_fn = s:fn.'\%(.*end\)\@!'
let s:block_start = '\%(\<do\>\|'.s:fn.'\)\>'
let s:multiline_block = '\%(\<do\>'.s:no_colon_after.'\|'.s:multiline_fn.'\)'
let s:block_middle = '\<\%(else\|match\|elsif\|catch\|after\|rescue\)\>'
let s:block_end = 'end'
let s:starts_with_pipeline = '^\s*|>.*$'
let s:ending_with_assignment = '=\s*$'

let s:indent_keywords = s:no_colon_before.'\%('.s:multiline_block.'\|'.s:block_middle.'\)'
let s:deindent_keywords = '^\s*\<\%('.s:block_end.'\|'.s:block_middle.'\)\>'

let s:pair_start = '\<\%('.s:no_colon_before.s:block_start.'\)\>'.s:no_colon_after
let s:pair_middle = '^\s*\%('.s:block_middle.'\)\>'.s:no_colon_after.'\zs'
let s:pair_end = '\<\%('.s:no_colon_before.s:block_end.'\)\>\zs'

function! GetElixirIndent()
  call s:build_data()
  let b:old_ind = get(b:, 'old_ind', {})

  if s:last_line_ref == 0
    " At the start of the file use zero indent.
    let b:old_ind = {}
    return 0
  elseif !s:is_indentable_at(s:current_line_ref, 1)
    " Current syntax is not indentable, keep last line indentation
    return indent(s:last_line_ref)
  else
    let ind = indent(s:last_line_ref)
    let ind = s:deindent_case_arrow(ind)
    let ind = s:indent_parenthesis(ind)
    let ind = s:indent_square_brackets(ind)
    let ind = s:indent_brackets(ind)
    let ind = s:deindent_opened_symbols(ind)
    let ind = s:indent_pipeline_assignment(ind)
    let ind = s:indent_pipeline_continuation(ind)
    let ind = s:indent_after_pipeline(ind)
    let ind = s:indent_assignment(ind)
    let ind = s:indent_ending_symbols(ind)
    let ind = s:indent_keywords(ind)
    let ind = s:deindent_keywords(ind)
    let ind = s:deindent_ending_symbols(ind)
    let ind = s:indent_case_arrow(ind)
    return ind
  end
endfunction

function! s:build_data()
  let s:current_line_ref = v:lnum
  let s:last_line_ref = prevnonblank(s:current_line_ref - 1)
  let s:current_line = getline(s:current_line_ref)
  let s:last_line = getline(s:last_line_ref)

  if s:last_line !~ s:arrow
    let s:pending_parenthesis = s:count_indentable_symbol_diff('(', '\%(end\s*\)\@<!)')
    let s:pending_square_brackets = s:count_indentable_symbol_diff('[', ']')
    let s:pending_brackets = s:count_indentable_symbol_diff('{', '}')
  end
endfunction

function! s:count_indentable_symbol_diff(open, close)
  if s:is_indentable_match(s:last_line_ref, a:open)
        \ && s:is_indentable_match(s:last_line_ref, a:close)
    return
          \   s:count_pattern(s:last_line, a:open)
          \ - s:count_pattern(s:last_line, a:close)
  else
    return 0
  end
endfunction

function! s:count_pattern(string, pattern)
  let size = strlen(a:string)
  let index = 0
  let counter = 0

  while index < size
    let index = match(a:string, a:pattern, index)
    if index >= 0
      let index += 1
      let counter +=1
    else
      break
    end
  endwhile

  return counter
endfunction

function! s:is_indentable_at(line, col)
  " TODO: Remove these 2 lines
  " I don't know why, but for the test on spec/indent/lists_spec.rb:24.
  " Vim is making some mess on parsing the syntax of 'end', it is being
  " recognized as 'elixirString' when should be recognized as 'elixirBlock'.
  call synID(a:line, a:col, 1)
  " This forces vim to sync the syntax.
  syntax sync fromstart

  return synIDattr(synID(a:line, a:col, 1), "name")
        \ !~ s:skip_syntax
endfunction

function! s:is_indentable_match(line, pattern)
  return s:is_indentable_at(a:line, match(getline(a:line), a:pattern))
endfunction

function! s:indent_parenthesis(ind)
  if s:pending_parenthesis > 0
        \ && s:last_line !~ '^\s*def'
        \ && s:last_line !~ s:end_with_arrow
    let b:old_ind.symbol = a:ind
    return matchend(s:last_line, '(')
  else
    return a:ind
  end
endfunction

function! s:indent_square_brackets(ind)
  if s:pending_square_brackets > 0
    if s:last_line =~ '[\s*$'
      return a:ind + &sw
    else
      " if start symbol is followed by a character, indent based on the
      " whitespace after the symbol, otherwise use the default shiftwidth
      " Avoid negative indentation index
      return matchend(s:last_line, '[\s*')
    end
  else
    return a:ind
  end
endfunction

function! s:indent_brackets(ind)
  if s:pending_brackets > 0
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:deindent_opened_symbols(ind)
  let s:opened_symbol =
        \   s:pending_parenthesis
        \ + s:pending_square_brackets
        \ + s:pending_brackets

  if s:opened_symbol < 0
    let ind = get(b:old_ind, 'symbol', a:ind + (s:opened_symbol * &sw))
    let ind = float2nr(ceil(floor(ind)/&sw)*&sw)
    return ind <= 0 ? 0 : ind
  else
    return a:ind
  end
endfunction

function! s:indent_pipeline_assignment(ind)
  if s:current_line =~ s:starts_with_pipeline
        \ && s:last_line =~ '^[^=]\+=.\+$'
    let b:old_ind.pipeline = indent(s:last_line_ref)
    " if line starts with pipeline
    " and last line is an attribution
    " indents pipeline in same level as attribution
    return match(s:last_line, '=\s*\zs[^ ]')
  else
    return a:ind
  end
endfunction

function! s:indent_pipeline_continuation(ind)
  if s:last_line =~ s:starts_with_pipeline
        \ && s:current_line =~ s:starts_with_pipeline
    return indent(s:last_line_ref)
  else
    return a:ind
  end
endfunction

function! s:indent_after_pipeline(ind)
  if s:last_line =~ s:starts_with_pipeline
    if empty(substitute(s:current_line, ' ', '', 'g'))
          \ || s:current_line =~ s:starts_with_pipeline
      return indent(s:last_line_ref)
    elseif s:last_line !~ s:indent_keywords
      let ind = b:old_ind.pipeline
      let b:old_ind.pipeline = 0
      return ind
    end
  end

  return a:ind
endfunction

function! s:indent_assignment(ind)
  if s:last_line =~ s:ending_with_assignment
    let b:old_ind.pipeline = indent(s:last_line_ref) " FIXME: side effect
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:indent_ending_symbols(ind)
  if s:last_line =~ '^\s*\('.s:ending_symbols.'\)\s*$'
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:indent_keywords(ind)
  if s:last_line =~ s:indent_keywords
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:deindent_keywords(ind)
  if s:current_line =~ s:deindent_keywords
    let bslnum = searchpair(
          \ s:pair_start,
          \ s:pair_middle,
          \ s:pair_end,
          \ 'nbW',
          \ s:block_skip
          \ )

    return indent(bslnum)
  else
    return a:ind
  end
endfunction

function! s:deindent_ending_symbols(ind)
  if s:current_line =~ '^\s*\('.s:ending_symbols.'\)'
    return a:ind - &sw
  else
    return a:ind
  end
endfunction

function! s:deindent_case_arrow(ind)
  if get(b:old_ind, 'arrow', 0) > 0
        \ && (s:current_line =~ s:arrow
        \ || s:current_line =~ s:block_end)
    let ind = b:old_ind.arrow
    let b:old_ind.arrow = 0
    return ind
  else
    return a:ind
  end
endfunction

function! s:indent_case_arrow(ind)
  if s:last_line =~ s:end_with_arrow && s:last_line !~ '\<fn\>'
    let b:old_ind.arrow = a:ind
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
