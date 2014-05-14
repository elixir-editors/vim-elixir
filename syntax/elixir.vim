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

syn keyword elixirKeyword abs apply atom_to_binary atom_to_list binary_part binary_to_atom binary_to_existing_atom binary_to_float binary_to_integer bit_size bitstring_to_list byte_size div elem exit float_to_binary float_to_list function_exported?  hd inspect integer_to_binary integer_to_list iolist_size iolist_to_binary is_atom is_binary is_bitstring is_boolean is_float is_function is_integer is_list is_number is_pid is_port is_reference is_tuple length list_to_atom list_to_bitstring list_to_existing_atom list_to_float list_to_integer list_to_tuple macro_exported?  make_ref max min module_info node rem round self send set_elem size spawn spawn_link throw tl trunc tuple_size tuple_to_list

syn keyword elixirKeyword access alias! binding is_exception is_range is_record is_regex match? nil? to_string var! case cond bc lc for inlist inbits if unless try receive quote unquote unquote_splicing super exit raise throw after rescue catch else for

syn match   elixirKeyword '\<\%(->\)\>\s*'

syn keyword elixirInclude import require alias use

syn keyword elixirTestKeyword test assert assert_receive assert_in_delta assert_received assert_raise catch_error catch_exit catch_throw flunk refute refute_receive refute_received refute_in_delta setup setup_all teardown teardown_all

syn keyword elixirOperator and not or when xor in

syn match elixirOperator '%=\|\*=\|\*\*=\|+=\|-=\|\^=\|||='
syn match elixirOperator "\%(<=>\|<\%(<\|=\)\@!\|>\%(<\|=\|>\)\@!\|<=\|>=\|===\|==\|=\~\|!=\|!\~\|\s?[ \t]\@=\)"
syn match elixirOperator "!+[ \t]\@=\|&&\|||\|\^\|\*\|+\|-\|/"
syn match elixirOperator "|\|++\|--\|\*\*\|\/\/\|\\\\\|<-\|<>\|<<\|>>\|=\|\.\|::"

syn match elixirSymbol '\(:\)\@<!:\%([a-zA-Z_]\w*\%([?!]\|=[>=]\@!\)\?\|<>\|===\?\|>=\?\|<=\?\)'
syn match elixirSymbol '\(:\)\@<!:\%(<=>\|&&\?\|%\(()\|\[\]\|{}\)\|++\?\|--\?\|||\?\|!\|//\|[%&`/|]\)'
syn match elixirSymbol "\%([a-zA-Z_]\w*\([?!]\)\?\):\(:\)\@!"

syn keyword elixirName nil
syn match   elixirName '\<[A-Z]\w*\>'

syn match elixirUnusedVariable '\<_\w*\>'

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

syn region elixirDocStringStart matchgroup=elixirDocString start=+"""+ end=+$+ oneline contains=ALLBUT,@elixirNotTop
syn region elixirDocStringStart matchgroup=elixirDocString start=+'''+ end=+$+ oneline contains=ALLBUT,@elixirNotTop
syn region elixirDocString     start=+\z("""\)+ end=+^\s*\zs\z1+ contains=elixirDocStringStart,elixirTodo,elixirInterpolation fold keepend
syn region elixirDocString     start=+\z('''\)+ end=+^\s*\zs\z1+ contains=elixirDocStringStart,elixirTodo,elixirInterpolation fold keepend

syn match elixirSymbolInterpolated ':\("\)\@=' contains=elixirString
syn match elixirString             "\(\w\)\@<!?\%(\\\(x\d{1,2}\|\h{1,2}\h\@!\>\|0[0-7]{0,2}[0-7]\@!\>\|[^x0MC]\)\|(\\[MC]-)+\w\|[^\s\\]\)"

syn region elixirBlock              matchgroup=elixirKeyword start="\<do\>\(:\)\@!" end="\<end\>" contains=ALLBUT,@elixirNotTop fold
syn region elixirAnonymousFunction  matchgroup=elixirKeyword start="\<fn\>"         end="\<end\>" contains=ALLBUT,@elixirNotTop fold

syn region elixirArguments start="(" end=")" contained contains=elixirOperator,elixirSymbol,elixirPseudoVariable,elixirName,elixirBoolean,elixirVariable,elixirUnusedVariable,elixirNumber,elixirDocString,elixirSymbolInterpolated,elixirRegex,elixirString,elixirDelimiter

syn match elixirDelimEscape "\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region elixirSigil matchgroup=elixirDelimiter start="[~]\z([~`!@#$%^&*_\-+|\:;"',.?/]\)"        end="\z1" skip="\\\\\|\\\z1" fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][SCRW]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][SCRW]\={"                              end="}"   skip="\\\\\|\\}"   contains=elixirDelimEscape fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][SCRW]\=<"                              end=">"   skip="\\\\\|\\>"   contains=elixirDelimEscape fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][SCRW]\=\["                             end="\]"  skip="\\\\\|\\\]"  contains=elixirDelimEscape fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][SCRW]\=("                              end=")"   skip="\\\\\|\\)"   contains=elixirDelimEscape fold

syn region elixirSigil matchgroup=elixirDelimiter start="[~][scrw]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region elixirSigil matchgroup=elixirDelimiter start="[~][scrw]{"                                end="}"   skip="\\\\\|\\}"   fold contains=@elixirStringContained,elixirRegexEscapePunctuation
syn region elixirSigil matchgroup=elixirDelimiter start="[~][scrw]<"                                end=">"   skip="\\\\\|\\>"   fold contains=@elixirStringContained,elixirRegexEscapePunctuation
syn region elixirSigil matchgroup=elixirDelimiter start="[~][scrw]\["                               end="\]"  skip="\\\\\|\\\]"  fold contains=@elixirStringContained,elixirRegexEscapePunctuation
syn region elixirSigil matchgroup=elixirDelimiter start="[~][scrw]("                                end=")"   skip="\\\\\|\\)"   fold contains=@elixirStringContained,elixirRegexEscapePunctuation

" Sigils surrounded with docString
syn region elixirSigil matchgroup=elixirDelimiter start=+[~][SCRWscrw]\z("""\)+ end=+^\s*\zs\z1+ skip=+\\"+ fold
syn region elixirSigil matchgroup=elixirDelimiter start=+[~][SCRWscrw]\z('''\)+ end=+^\s*\zs\z1+ skip=+\\'+ fold

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
syn match  elixirRecordDeclaration      "[^[:space:];#<]\+"        contained contains=elixirName,elixirSymbol              skipwhite skipnl
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
hi def link elixirTestKeyword            Keyword
hi def link elixirOperator               Operator
hi def link elixirSymbol                 Constant
hi def link elixirPseudoVariable         Constant
hi def link elixirName                   Type
hi def link elixirBoolean                Boolean
hi def link elixirVariable               Identifier
hi def link elixirUnusedVariable         Comment
hi def link elixirNumber                 Number
hi def link elixirDocString              String
hi def link elixirSymbolInterpolated     elixirSymbol
hi def link elixirRegex                  elixirString
hi def link elixirRegexEscape            elixirSpecial
hi def link elixirRegexEscapePunctuation elixirSpecial
hi def link elixirRegexCharClass         elixirSpecial
hi def link elixirRegexQuantifier        elixirSpecial
hi def link elixirSpecial                Special
hi def link elixirString                 String
hi def link elixirSigil                  String
hi def link elixirDelimiter              Delimiter
