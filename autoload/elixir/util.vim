let s:SKIP_SYNTAX = '\%(Comment\|String\)$'

function! elixir#util#is_indentable_at(line, col)
  if a:col == -1 " skip synID lookup for not found match
    return 1
  end
  " TODO: Remove these 2 lines
  " I don't know why, but for the test on spec/indent/lists_spec.rb:24.
  " Vim is making some mess on parsing the syntax of 'end', it is being
  " recognized as 'elixirString' when should be recognized as 'elixirBlock'.
  call synID(a:line, a:col, 1)
  " This forces vim to sync the syntax. Using fromstart is very slow on files
  " over 1k lines
  syntax sync minlines=20 maxlines=150

  return synIDattr(synID(a:line, a:col, 1), "name")
        \ !~ s:SKIP_SYNTAX
endfunction

" Return the column of an indentable match which matches
" the given regex or -1
function! elixir#util#find_indentable(line, regex)
  return s:find_indentable(a:line, 0, a:regex)
endfunction

function! s:find_indentable(line, col, regex)
  let substr = strpart(a:line.text, a:col)

  " Recursion base case: no matches left to check in line
  let idx = match(substr, a:regex)
  if idx == -1
    return -1
  end

  " Was match, so if indentable return idx of this match
  if elixir#util#is_indentable_at(a:line.num, idx)
    return idx
  else
    " Increment the idx and recurse
    return s:find_indentable(a:line, idx + 1, a:regex)
  end
endfunction

function! elixir#util#count_indentable_symbol_diff(line, open, close)
  return
        \   s:match_count(a:line, a:open)
        \ - s:match_count(a:line, a:close)
endfunction

function! s:match_count(line, pattern)
  let size = strlen(a:line.text)
  let index = 0
  let counter = 0

  while index < size
    let index = match(a:line.text, a:pattern, index)
    if index >= 0
      let index += 1
      if elixir#util#is_indentable_at(a:line.num, index)
        let counter +=1
      end
    else
      break
    end
  endwhile

  return counter
endfunction

function elixir#util#is_blank(string)
  return a:string =~ '^\s*$'
endfunction
