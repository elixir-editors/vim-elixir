" Vim filetype plugin
" Language:    Elixir
" Maintainer:  Carlos Galdino <carloshsgaldino@gmail.com>
" URL:         https://github.com/elixir-lang/vim-elixir

if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1

setlocal comments=:#
setlocal commentstring=#\ %s
