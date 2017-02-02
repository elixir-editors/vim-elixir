au BufRead,BufNewFile *.ex,*.exs call s:setf('elixir')
au BufRead,BufNewFile *.eex call s:setf('eelixir')
au BufRead,BufNewFile * call s:DetectElixir()

au FileType elixir,eelixir setl sw=2 sts=2 et iskeyword+=!,?

// fix for https://github.com/elixir-lang/vim-elixir/issues/121
let g:filetype_euphoria = 'elixir'

function! s:setf(filetype) abort
  let &filetype = a:filetype
endfunction

function! s:DetectElixir()
  if getline(1) =~ '^#!.*\<elixir\>'
    call s:setf('elixir')
  endif
endfunction
