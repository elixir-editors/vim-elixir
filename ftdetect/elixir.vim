au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
au FileType elixir setl sw=2 sts=2 et iskeyword+=!,?

function! s:DetectElixir()
    if getline(1) =~ '^#!.*\<elixir\>'
        set filetype=elixir
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectElixir()
