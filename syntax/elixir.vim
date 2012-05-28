" Vim syntax file
" Language: Elixir
" Maintainer: Carlos Galdino <carloshsgaldino@gmail.com>
" Last Change: 2012 Mar 26

if exists("b:current_syntax")
  finish
endif

" syncing starts 2000 lines before top line so docstrings don't screw things up
syn sync minlines=2000

syn match elixirComment '#.*'

syn match elixirKeyword '\<\%(case\|end\|bc\|lc\|if\|unless\|try\|loop\|receive\|fn\|defmodule\|defprotocol\|defimpl\|defrecord\|defmacro\|defdelegate\|defexception\|defp\|def\|exit\|raise\|throw\)\>[?!]\@!'
syn match elixirKeyword '\<\%(do\|->\)\>\s*'
syn match elixirKeyword '\<\%(import\|require\|use\|recur\|quote\|unquote\|super\|refer\)\>[?!]\@!'

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

syn match elixirPseudoVariable '\<__\%(FILE\|LINE\|MODULE\|LOCAL\|MAIN\|FUNCTION\)__\>[?!]\@!'

syn match elixirNumber '\<\d\(_\?\d\)*\(\.[^[:space:][:digit:]]\@!\(_\?\d\)*\)\?\([eE][-+]\?\d\(_\?\d\)*\)\?\>'
syn match elixirNumber '\<0[xX][0-9A-Fa-f]\+\>'
syn match elixirNumber '\<0[bB][01]\+\>'

syn match elixirRegexEscape    "\\\\\|\\[aAbBcdDefGhHnrsStvVwW]\|\\\d\{3}\|\\x[0-9a-fA-F]\{2}"
syn match elixirRegexCharClass "\[:\(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|xdigit\):\]"

syn region elixirString        start="'" end="'"
syn region elixirString        start='"' end='"' contains=elixirInterpolation,elixirRegexEscape,elixirRegexCharClass
syn region elixirInterpolation start="#{" end="}" contained contains=ALLBUT,elixirComment
syn region elixirDocString     start=+"""+ end=+"""+
syn region elixirDocString     start=+'''+ end=+'''+

syn match elixirSymbolInterpolated ':\("\)\@=' contains=elixirString
syn match elixirString             "\(\w\)\@<!?\%(\\\(x\d{1,2}\|\h{1,2}\h\@!\>\|0[0-7]{0,2}[0-7]\@!\>\|[^x0MC]\)\|(\\[MC]-)+\w\|[^\s\\]\)"

hi def link elixirComment             Comment
hi def link elixirKeyword             Keyword
hi def link elixirOperator            Operator
hi def link elixirSymbol              Constant
hi def link elixirPseudoVariable      Constant
hi def link elixirName                Type
hi def link elixirBoolean             Boolean
hi def link elixirVariable            Identifier
hi def link elixirNumber              Number
hi def link elixirDocString           Comment
hi def link elixirInterpolation       Delimiter
hi def link elixirSymbolInterpolated  elixirSymbol
hi def link elixirRegexEscape         Special
hi def link elixirRegexCharClass      Special
hi def link elixirString              String
