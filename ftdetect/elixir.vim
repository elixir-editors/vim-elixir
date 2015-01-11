function! s:setf(filetype) abort
    if &filetype !=# a:filetype
        let &filetype = a:filetype
    endif
endfunction

au BufRead,BufNewFile *.ex,*.exs call s:setf('elixir')
au BufRead,BufNewFile *.eex call s:setf('eelixir')

au FileType elixir,eelixir setl sw=2 sts=2 et iskeyword+=!,?

function! s:DetectElixir()
    if getline(1) =~ '^#!.*\<elixir\>'
        call s:setf('elixir')
    endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectElixir()
