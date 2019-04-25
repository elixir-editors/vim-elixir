au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
au BufRead,BufNewFile *.eex,*.leex set filetype=eelixir
au BufRead,BufNewFile * call s:DetectElixir()

function! s:DetectElixir()
  if (!did_filetype() || &filetype !=# 'elixir') && getline(1) =~# '^#!.*\<elixir\>'
    set filetype=elixir
  endif
endfunction
