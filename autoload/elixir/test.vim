let s:awk_filter =  ['{gsub("^ *","")}']
let s:awk_filter += ['/^Assertion/{a=$0}']
let s:awk_filter += ['/^code:/{gsub("code: *","");c=$0}']
let s:awk_filter += ['/^stacktrace:/{getline; gsub("^ *",""); print $0 ":" a " " c}']
let s:awk_filter_prg = shellescape(join(s:awk_filter, ";"))

function! s:test(prog)
  let &makeprg = 'mix test ' . a:prog . ' \| awk -n ' . s:awk_filter_prg
  let &efm = '%f:%l:%m'
  if exists("g:after_make_bg")
    let l:background=g:after_make_bg
  else
    let l:background=&background
  endif
  if exists("g:colors_name")
    let l:colors_name=g:colors_name
  endif
  silent exe 'make'
  exe 'copen'
  let &background=l:background
  if exists("g:colors_name")
    exe 'colorscheme ' . l:colors_name
  endif
endfunction

function! elixir#test#run(prog)
  let makeprg = &makeprg
  let efm = &efm
  try
    call s:test(a:prog)
  finally
    let &makeprg = makeprg
    let &efm = efm
  endtry
endfunction
