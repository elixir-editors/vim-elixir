if (exists("b:did_ftplugin"))
  finish
endif
let b:did_ftplugin = 1


" Matchit support
if exists("loaded_matchit") && !exists("b:match_words")
  let b:match_ignorecase = 0

  let b:match_words = '\:\@<!\<\%(do\|fn\)\:\@!\>' .
        \ ':' .
        \ '\<\%(else\|elsif\|catch\|after\|rescue\)\:\@!\>' .
        \ ':' .
        \ '\:\@<!\<end\>' .
        \ ',{:},\[:\],(:)'
endif

setlocal comments=:#
setlocal commentstring=#\ %s

setlocal iskeyword+=.
setlocal keywordprg=iex\ -e\ 'Code.eval_string(\"import\ IEx.Helpers;\ h\ \"\ <>\ hd(System.argv));\ System.halt(0)'\ --
