" Vim syntax file
" Language: Elixir
" Maintainer: Carlos Galdino <carloshsgaldino@gmail.com>
" Last Change: 2013 Apr 24

if exists("b:current_syntax")
  finish
endif

" syncing starts 2000 lines before top line so docstrings don't screw things up
syn sync minlines=2000

syn match elixirComment '#.*' contains=elixirTodo
syn keyword elixirTodo FIXME NOTE TODO OPTIMIZE XXX HACK contained

syn match elixirKeyword '\<\%(case\|cond\|end\|bc\|lc\|inlist\|inbits\|if\|unless\|try\|loop\|receive\|fn\)\>[?!]\@!'
syn match elixirKeyword '\<\%(defmodule\|defprotocol\|defimpl\|defrecord\|defmacrop\?\|defdelegate\|defoverridable\|defexception\|defcallback\|defp\?\)\>[?!]\@!'
syn match elixirKeyword '\<\%(exit\|raise\|throw\|after\|rescue\|catch\|else\)\>[?!]\@!'
syn match elixirKeyword '\<\%(do\|->\)\>\s*'
syn match elixirKeyword '\<\%(import\|require\|use\|recur\|quote\|unquote\|super\|alias\)\>[?!]\@!'

syn match elixirOperator '\<\%(and\|not\|or\|when\|xor\|in\)\>'
syn match elixirOperator '%=\|\*=\|\*\*=\|+=\|-=\|\^=\|||='
syn match elixirOperator "\%(<=>\|<\%(<\|=\)\@!\|>\%(<\|=\|>\)\@!\|<=\|>=\|===\|==\|=\~\|!=\|!\~\|?[ \t]\@=\)"
syn match elixirOperator "!+[ \t]\@=\|&&\|||\|\^\|\*\|+\|-\|/"
syn match elixirOperator "|\|++\|--\|\*\*\|\/\/\|<-\|<>\|<<\|>>\|=\|\."

syn match elixirSymbol '\(:\)\@<!:\%([a-zA-Z_]\w*\%([?!]\|=[>=]\@!\)\?\|<>\|===\?\|>=\?\|<=\?\)'
syn match elixirSymbol '\(:\)\@<!:\%(<=>\|&&\?\|%\(()\|\[\]\|{}\)\|++\?\|--\?\|||\?\|!\|//\|[%&`/|]\)'
syn match elixirSymbol "\%([a-zA-Z_]\w*\([?!]\)\?\):\(:\)\@!"

syn match elixirName '\<nil\>[?!]\@!\|\<[A-Z]\w*\>'

syn match elixirBoolean 'true\|false'

syn match elixirVariable '@[a-zA-Z_]\w*\|&\d'

syn match elixirPseudoVariable '\<__\%(FILE\|MODULE\|MAIN\|ENV\|CALLER\)__\>[?!]\@!'

syn match elixirNumber '\<\d\(_\?\d\)*\(\.[^[:space:][:digit:]]\@!\(_\?\d\)*\)\?\([eE][-+]\?\d\(_\?\d\)*\)\?\>'
syn match elixirNumber '\<0[xX][0-9A-Fa-f]\+\>'
syn match elixirNumber '\<0[bB][01]\+\>'

syn match elixirRegexEscape            "\\\\\|\\[aAbBcdDefGhHnrsStvVwW]\|\\\d\{3}\|\\x[0-9a-fA-F]\{2}" contained
syn match elixirRegexEscapePunctuation "?\|\.\|*\|\[\|\]\|+\|\^\|\$\||\|(\|)\|{\|}" contained
syn match elixirRegexQuantifier        "[*?+][?+]\=" contained display
syn match elixirRegexQuantifier        "{\d\+\%(,\d*\)\=}?\=" contained display
syn match elixirRegexCharClass         "\[:\(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|xdigit\):\]" contained display

syn region elixirRegex matchgroup=elixirDelimiter start="%r/" end="/[uiomxfr]*" skip="\\\\" contains=@elixirRegexSpecial

syn cluster elixirRegexSpecial   contains=elixirRegexEscape,elixirRegexCharClass,elixirRegexQuantifier
syn cluster elixirStringContained contains=elixirInterpolation,elixirRegexEscape,elixirRegexCharClass

syn region elixirString        matchgroup=elixirDelimiter start="'" end="'" skip="\\'"
syn region elixirString        matchgroup=elixirDelimiter start='"' end='"' skip='\\"' contains=@elixirStringContained
syn region elixirInterpolation matchgroup=elixirDelimiter start="#{" end="}" contained contains=ALLBUT,elixirComment
syn region elixirDocString     start=+"""+ end=+"""+ contains=elixirTodo
syn region elixirDocString     start=+'''+ end=+'''+ contains=elixirTodo

syn match elixirSymbolInterpolated ':\("\)\@=' contains=elixirString
syn match elixirString             "\(\w\)\@<!?\%(\\\(x\d{1,2}\|\h{1,2}\h\@!\>\|0[0-7]{0,2}[0-7]\@!\>\|[^x0MC]\)\|(\\[MC]-)+\w\|[^\s\\]\)"

hi def link elixirComment                Comment
hi def link elixirTodo                   Todo
hi def link elixirKeyword                Keyword
hi def link elixirOperator               Operator
hi def link elixirSymbol                 Constant
hi def link elixirPseudoVariable         Constant
hi def link elixirName                   Type
hi def link elixirBoolean                Boolean
hi def link elixirVariable               Identifier
hi def link elixirNumber                 Number
hi def link elixirDocString              Comment
hi def link elixirInterpolation          Delimiter
hi def link elixirSymbolInterpolated     elixirSymbol
hi def link elixirRegex                  elixirString
hi def link elixirRegexEscape            elixirSpecial
hi def link elixirRegexEscapePunctuation elixirSpecial
hi def link elixirRegexCharClass         elixirSpecial
hi def link elixirRegexQuantifier        elixirSpecial
hi def link elixirSpecial                Special
hi def link elixirString                 String
hi def link elixirDelimiter              Delimiter
