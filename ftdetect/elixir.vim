au BufRead,BufNewFile *.ex,*.exs setfiletype elixir
au BufRead,BufNewFile *.eex setfiletype eelixir
au BufRead,BufNewFile * call s:DetectElixir()

function! s:DetectElixir()
  if &filetype !=# 'elixir' && getline(1) =~# '^#!.*\<elixir\>'
    setlocal filetype=elixir
  endif
endfunction
