" Vim syntax file
" Language: Elixir
" Maintainer: Carlos Galdino <carloshsgaldino@gmail.com>
" Last Change: 2013 Apr 24

if exists("b:current_syntax")
  finish
endif

" syncing starts 2000 lines before top line so docstrings don't screw things up
syn sync minlines=2000

syn cluster elixirNotTop contains=@elixirRegexSpecial,@elixirStringContained,@elixirDeclaration,elixirTodo,elixirArguments

syn match elixirComment '#.*' contains=elixirTodo
syn keyword elixirTodo FIXME NOTE TODO OPTIMIZE XXX HACK contained

syn keyword elixirKeyword case cond bc lc inlist inbits if unless try receive function
syn keyword elixirKeyword exit raise throw after rescue catch else
syn keyword elixirKeyword use quote unquote super alias
syn match   elixirKeyword '\<\%(->\)\>\s*'

syn keyword elixirInclude import require

syn keyword elixirOperator and not or when xor in
syn match elixirOperator '%=\|\*=\|\*\*=\|+=\|-=\|\^=\|||='
syn match elixirOperator "\%(<=>\|<\%(<\|=\)\@!\|>\%(<\|=\|>\)\@!\|<=\|>=\|===\|==\|=\~\|!=\|!\~\|?[ \t]\@=\)"
syn match elixirOperator "!+[ \t]\@=\|&&\|||\|\^\|\*\|+\|-\|/"
syn match elixirOperator "|\|++\|--\|\*\*\|\/\/\|<-\|<>\|<<\|>>\|=\|\.\|::"

syn match elixirSymbol '\(:\)\@<!:\%([a-zA-Z_]\w*\%([?!]\|=[>=]\@!\)\?\|<>\|===\?\|>=\?\|<=\?\)'
syn match elixirSymbol '\(:\)\@<!:\%(<=>\|&&\?\|%\(()\|\[\]\|{}\)\|++\?\|--\?\|||\?\|!\|//\|[%&`/|]\)'
syn match elixirSymbol "\%([a-zA-Z_]\w*\([?!]\)\?\):\(:\)\@!"

syn keyword elixirName nil
syn match   elixirName '\<[A-Z]\w*\>'

syn keyword elixirBoolean true false

syn match elixirVariable '@[a-zA-Z_]\w*\|&\d'

syn keyword elixirPseudoVariable __FILE__ __DIR__ __MODULE__ __ENV__ __CALLER__

syn match elixirNumber '\<\d\(_\?\d\)*\(\.[^[:space:][:digit:]]\@!\(_\?\d\)*\)\?\([eE][-+]\?\d\(_\?\d\)*\)\?\>'
syn match elixirNumber '\<0[xX][0-9A-Fa-f]\+\>'
syn match elixirNumber '\<0[bB][01]\+\>'

syn match elixirRegexEscape            "\\\\\|\\[aAbBcdDefGhHnrsStvVwW]\|\\\d\{3}\|\\x[0-9a-fA-F]\{2}" contained
syn match elixirRegexEscapePunctuation "?\|\\.\|*\|\\\[\|\\\]\|+\|\\^\|\\\$\|\\|\|\\(\|\\)\|\\{\|\\}" contained
syn match elixirRegexQuantifier        "[*?+][?+]\=" contained display
syn match elixirRegexQuantifier        "{\d\+\%(,\d*\)\=}?\=" contained display
syn match elixirRegexCharClass         "\[:\(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|word\|xdigit\):\]" contained display

syn region elixirRegex matchgroup=elixirDelimiter start="%r/" end="/[uiomxfr]*" skip="\\\\" contains=@elixirRegexSpecial

syn cluster elixirRegexSpecial    contains=elixirRegexEscape,elixirRegexCharClass,elixirRegexQuantifier,elixirRegexEscapePunctuation
syn cluster elixirStringContained contains=elixirInterpolation,elixirRegexEscape,elixirRegexCharClass

syn region elixirString        matchgroup=elixirDelimiter start="'" end="'" skip="\\'"
syn region elixirString        matchgroup=elixirDelimiter start='"' end='"' skip='\\"' contains=@elixirStringContained
syn region elixirInterpolation matchgroup=elixirDelimiter start="#{" end="}" contained contains=ALLBUT,elixirComment,@elixirNotTop
syn region elixirDocString     start=+"""+ end=+"""+ contains=elixirTodo fold
syn region elixirDocString     start=+'''+ end=+'''+ contains=elixirTodo fold

syn match elixirSymbolInterpolated ':\("\)\@=' contains=elixirString
syn match elixirString             "\(\w\)\@<!?\%(\\\(x\d{1,2}\|\h{1,2}\h\@!\>\|0[0-7]{0,2}[0-7]\@!\>\|[^x0MC]\)\|(\\[MC]-)+\w\|[^\s\\]\)"

syn region elixirBlock              matchgroup=elixirKeyword start="\<do\>\(:\)\@!" end="\<end\>" contains=ALLBUT,@elixirNotTop fold
syn region elixirAnonymousFunction  matchgroup=elixirKeyword start="\<fn\>"         end="\<end\>" contains=ALLBUT,@elixirNotTop fold

syn region elixirArguments start="(" end=")" contained

" Defines
syn keyword elixirDefine              def            nextgroup=elixirFunctionDeclaration    skipwhite skipnl
syn keyword elixirDefine              def            nextgroup=elixirFunctionDeclaration    skipwhite skipnl
syn keyword elixirPrivateDefine       defp           nextgroup=elixirFunctionDeclaration    skipwhite skipnl
syn keyword elixirModuleDefine        defmodule      nextgroup=elixirModuleDeclaration      skipwhite skipnl
syn keyword elixirProtocolDefine      defprotocol    nextgroup=elixirProtocolDeclaration    skipwhite skipnl
syn keyword elixirImplDefine          defimpl        nextgroup=elixirImplDeclaration        skipwhite skipnl
syn keyword elixirRecordDefine        defrecord      nextgroup=elixirRecordDeclaration      skipwhite skipnl
syn keyword elixirPrivateRecordDefine defrecordp     nextgroup=elixirRecordDeclaration      skipwhite skipnl
syn keyword elixirMacroDefine         defmacro       nextgroup=elixirMacroDeclaration       skipwhite skipnl
syn keyword elixirPrivateMacroDefine  defmacrop      nextgroup=elixirMacroDeclaration       skipwhite skipnl
syn keyword elixirDelegateDefine      defdelegate    nextgroup=elixirDelegateDeclaration    skipwhite skipnl
syn keyword elixirOverridableDefine   defoverridable nextgroup=elixirOverridableDeclaration skipwhite skipnl
syn keyword elixirExceptionDefine     defexception   nextgroup=elixirExceptionDeclaration   skipwhite skipnl
syn keyword elixirCallbackDefine      defcallback    nextgroup=elixirCallbackDeclaration    skipwhite skipnl

" Declarations
syn match  elixirModuleDeclaration      "[^[:space:];#<]\+"        contained contains=elixirName nextgroup=elixirBlock     skipwhite skipnl
syn match  elixirFunctionDeclaration    "[^[:space:];#<,()\[\]]\+" contained                     nextgroup=elixirArguments skipwhite skipnl
syn match  elixirProtocolDeclaration    "[^[:space:];#<]\+"        contained contains=elixirName                           skipwhite skipnl
syn match  elixirImplDeclaration        "[^[:space:];#<]\+"        contained contains=elixirName                           skipwhite skipnl
syn match  elixirRecordDeclaration      "[^[:space:];#<]\+"        contained contains=elixirName                           skipwhite skipnl
syn match  elixirMacroDeclaration       "[^[:space:];#<,()\[\]]\+" contained                     nextgroup=elixirArguments skipwhite skipnl
syn match  elixirDelegateDeclaration    "[^[:space:];#<,()\[\]]\+" contained contains=elixirFunctionDeclaration            skipwhite skipnl
syn region elixirDelegateDeclaration    start='\['     end='\]'    contained contains=elixirFunctionDeclaration            skipwhite skipnl
syn match  elixirOverridableDeclaration "[^[:space:];#<]\+"        contained contains=elixirName                           skipwhite skipnl
syn match  elixirExceptionDeclaration   "[^[:space:];#<]\+"        contained contains=elixirName                           skipwhite skipnl
syn match  elixirCallbackDeclaration    "[^[:space:];#<,()\[\]]\+" contained contains=elixirFunctionDeclaration            skipwhite skipnl

syn cluster elixirDeclaration contains=elixirFunctionDeclaration,elixirModuleDeclaration,elixirProtocolDeclaration,elixirImplDeclaration,elixirRecordDeclaration,elixirMacroDeclaration,elixirDelegateDeclaration,elixirOverridableDeclaration,elixirExceptionDeclaration,elixirCallbackDeclaration

hi def link elixirDefine                 Define
hi def link elixirPrivateDefine          Define
hi def link elixirModuleDefine           Define
hi def link elixirProtocolDefine         Define
hi def link elixirImplDefine             Define
hi def link elixirRecordDefine           Define
hi def link elixirPrivateRecordDefine    Define
hi def link elixirMacroDefine            Define
hi def link elixirPrivateMacroDefine     Define
hi def link elixirDelegateDefine         Define
hi def link elixirOverridableDefine      Define
hi def link elixirExceptionDefine        Define
hi def link elixirCallbackDefine         Define
hi def link elixirFunctionDeclaration    Function
hi def link elixirMacroDeclaration       Macro
hi def link elixirInclude                Include
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
hi def link elixirSymbolInterpolated     elixirSymbol
hi def link elixirRegex                  elixirString
hi def link elixirRegexEscape            elixirSpecial
hi def link elixirRegexEscapePunctuation elixirSpecial
hi def link elixirRegexCharClass         elixirSpecial
hi def link elixirRegexQuantifier        elixirSpecial
hi def link elixirSpecial                Special
hi def link elixirString                 String
hi def link elixirDelimiter              Delimiter
