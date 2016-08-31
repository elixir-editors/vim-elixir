if exists("b:did_indent")
  finish
end
let b:did_indent = 1

setlocal nosmartindent

setlocal indentexpr=GetElixirIndent()
setlocal indentkeys+=0),0],0=end,0=else,0=match,0=elsif,0=catch,0=after,0=rescue

if exists("*GetElixirIndent")
  finish
end

let s:cpo_save = &cpo
set cpo&vim

let s:no_colon_before = ':\@<!'
let s:no_colon_after = ':\@!'
let s:symbols_end = '\]\|}\|)'
let s:symbols_start = '\[\|{\|('
let s:arrow = '^.*->$'
let s:skip_syntax = '\%(Comment\|String\)$'
let s:block_skip = "synIDattr(synID(line('.'),col('.'),1),'name') =~? '".s:skip_syntax."'"
let s:block_start = '\<\%(do\|fn\)\>'
let s:block_middle = 'else\|match\|elsif\|catch\|after\|rescue'
let s:block_end = 'end'
let s:starts_with_pipeline = '^\s*|>.*$'
let s:ending_with_assignment = '=\s*$'

let s:indent_keywords = '\<'.s:no_colon_before.'\%('.s:block_start.'\|'.s:block_middle.'\)$'.'\|'.s:arrow
let s:deindent_keywords = '^\s*\<\%('.s:block_end.'\|'.s:block_middle.'\)\>'.'\|'.s:arrow

let s:pair_start = '\<\%('.s:no_colon_before.s:block_start.'\)\>'.s:no_colon_after
let s:pair_middle = '\<\%('.s:block_middle.'\)\>'.s:no_colon_after.'\zs'
let s:pair_end = '\<\%('.s:no_colon_before.s:block_end.'\)\>\zs'

function! s:metadata()
  let metadata = {}
  let metadata.current_line_ref = v:lnum
  let metadata.last_line_ref = prevnonblank(metadata.current_line_ref - 1)
  let metadata.current_line = getline(metadata.current_line_ref)
  let metadata.last_line = getline(metadata.last_line_ref)
  let metadata.pending_parenthesis = 0
  let metadata.opened_symbol = 0

  if metadata.last_line !~ s:arrow
    let splitted_line = split(metadata.last_line, '\zs')
    let metadata.pending_parenthesis =
          \ + count(splitted_line, '(') - count(splitted_line, ')')
    let metadata.opened_symbol =
          \ + metadata.pending_parenthesis
          \ + count(splitted_line, '[') - count(splitted_line, ']')
          \ + count(splitted_line, '{') - count(splitted_line, '}')
  end

  return metadata
endfunction

function! s:continuing_parameter_list()
  " Follow the first parameter indent position when breaking parameters list
  " in many lines
  return
        \ s:metadata().pending_parenthesis > 0
        \ && s:metadata().last_line !~ '^\s*def'
        \ && s:metadata().last_line !~ s:arrow
endfunction

function! s:is_indentable_syntax()
  " TODO: Remove these 2 lines
  " I don't know why, but for the test on spec/indent/lists_spec.rb:24.
  " Vim is making some mess on parsing the syntax of 'end', it is being
  " recognized as 'elixirString' when should be recognized as 'elixirBlock'.
  call synID(s:metadata().current_line_ref, 1, 1)
  " This forces vim to sync the syntax.
  syntax sync fromstart

  return synIDattr(synID(s:metadata().current_line_ref, 1, 1), "name")
        \ !~ s:skip_syntax
endfunction

function! s:indent_opened_symbol(ind)
  if a:ind > 0 || s:metadata().opened_symbol > 0
    " if start symbol is followed by a character, indent based on the
    " whitespace after the symbol, otherwise use the default shiftwidth
    " Avoid negative indentation index
    if s:metadata().last_line =~ '\('.s:symbols_start.'\).'
      let regex = '\('.s:symbols_start.'\)\s*'
      let opened_prefix = matchlist(s:metadata().last_line, regex)[0]
      return a:ind + (s:metadata().opened_symbol * strlen(opened_prefix))
    else
      return a:ind + (s:metadata().opened_symbol * &sw)
    end
  else
    return a:ind
  end
endfunction

function! s:indent_last_line_end_symbol_or_indent_keyword(ind)
  if s:metadata().last_line =~ '^\s*\('.s:symbols_end.'\)'
        \ || s:metadata().last_line =~ s:indent_keywords
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:indent_symbols_ending(ind)
  if s:metadata().current_line =~ '^\s*\('.s:symbols_end.'\)'
    return a:ind - &sw
  else
    return a:ind
  end
endfunction

function! s:indent_assignment_ending(ind)
  if s:metadata().last_line =~ s:ending_with_assignment
        \ && s:metadata().opened_symbol == 0
    let b:old_ind = indent(s:metadata().last_line_ref) " FIXME: side effect
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! s:indent_pipeline(ind)
  if s:metadata().last_line =~ '|>.*$'
        \ && s:metadata().current_line =~ s:starts_with_pipeline
    " if line starts with pipeline
    " and last line ends with a pipeline,
    " align them
    return float2nr(match(s:metadata().last_line, '|>') / &sw) * &sw
  elseif s:metadata().current_line =~ s:starts_with_pipeline
        \ && s:metadata().last_line =~ '^[^=]\+=.\+$'
    if !exists('b:old_ind') || b:old_ind == 0 " FIXME: side effect
      let b:old_ind = indent(s:metadata().last_line_ref)
    end
    " if line starts with pipeline
    " and last line is an attribution
    " indents pipeline in same level as attribution
    return float2nr(matchend(s:metadata().last_line, '=\s*[^ ]') / &sw) * &sw
  else
    return a:ind
  end
endfunction

function! s:indent_after_pipeline(ind)
  if s:metadata().last_line =~ s:starts_with_pipeline
        \ && s:metadata().current_line !~ s:starts_with_pipeline
        \ && s:metadata().last_line !~ s:indent_keywords
    " if last line starts with pipeline
    " and current line doesn't start with pipeline
    " returns the indentation before the pipeline
    return b:old_ind
  else
    return a:ind
  end
endfunction

function! s:indent_keyword(ind)
  if s:metadata().current_line =~ s:deindent_keywords
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

function! s:indent_arrow(ind)
  if s:metadata().current_line =~ s:arrow
    " indent case statements '->'
    return a:ind + &sw
  else
    return a:ind
  end
endfunction

function! GetElixirIndent()
  if s:metadata().last_line_ref == 0
    " At the start of the file use zero indent.
    return 0
  elseif s:continuing_parameter_list()
    return match(s:metadata().last_line, '(') + 1
  elseif !s:is_indentable_syntax()
    " Current syntax is not indentable, keep last line indentation
    return indent(s:metadata().last_line_ref)
  else
    let ind = indent(s:metadata().last_line_ref)
    let ind = s:indent_opened_symbol(ind)
    let ind = s:indent_last_line_end_symbol_or_indent_keyword(ind)
    let ind = s:indent_symbols_ending(ind)
    let ind = s:indent_assignment_ending(ind)
    let ind = s:indent_pipeline(ind)
    let ind = s:indent_after_pipeline(ind)
    let ind = s:indent_keyword(ind)
    let ind = s:indent_arrow(ind)
    return ind
  end
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
