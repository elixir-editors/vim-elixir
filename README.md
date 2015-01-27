# vim-elixir

[![Build Status](https://travis-ci.org/elixir-lang/vim-elixir.svg?branch=master)](https://travis-ci.org/elixir-lang/vim-elixir)

[Elixir](http://elixir-lang.org) support for vim. This plugin also adds support
for Elixir's templating language, EEx.

Features included so far:

* Syntax highlighting for Elixir and EEx
* Filetype detection for `.ex`, `.exs` and `.eex` files
* Automatic indentation

Using NVim (simply [install it](https://github.com/neovim/neovim/wiki/Installin://github.com/neovim/neovim/wiki/Installing) and rename your `.vimrc` and `.vim` in
`.nvimrc` `.nvim`, and run `:UpdateRemotePlugins` to update remote plugin database), extra features are :
* Omni completion `CTRL-X-O` (with module/fun docs in the preview window)
* Load nearest mix project in current file path with `:MixLoad`
* Start the current mix project application inside your vim : `:MixStart`
* Interpret the currently selected Elixir Code with `:ElixirExec`
  * If no line selected, then the whole file is interpreted, useful
    to dynamically reload current file modules when the app runs with `:MixStart`
  * Bindings are kept along interpretations
  * You can reset binding using the bang : `:ElixirExec!`


## Installation

### Plugin managers

The most common plugin managers include [vim-plug][vim-plug],
[NeoBundle][neobundle], [Vundle][vundle] and [pathogen.vim][pathogen].

With pathogen.vim, just clone this repository inside `~/.vim/bundle`:

```bash
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir
```

With the other plugin managers, just follow the instructions on the homepage of
each plugin. In general, you have to add a line to your `~/.vimrc`:

```viml
" vim-plug
Plug 'elixir-lang/vim-elixir'
" NeoBundle
NeoBundle 'elixir-lang/vim-elixir'
" Vundle
Plugin 'elixir-lang/vim-elixir'
```

### Manual installation

Copy the contents of each directory in the respective directories inside
`~/.vim`.


## Syntastic integration

> :warning: **Warning:** older versions (`<= 3.4.0-106`) of
> [Syntastic][syntastic] check Elixir scripts *by executing them*. In addition
> to being unsafe, this can cause Vim to hang while saving Elixir scripts. This
> is not an error in `vim-elixir`. This issue [can be fixed in
> Syntastic][syntastic-issue-fix] by disabling Elixir checking by default.
>
> **If your version of Syntastic is below `3.4.0-107` (16 July 2014), you should
> update to a newer version.**

[vim-plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[neobundle]: https://github.com/Shougo/neobundle.vim
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[syntastic-issue-fix]: https://github.com/scrooloose/syntastic/commit/1d19dff701524ebed90a4fbd7c7cd75ab954b79d
