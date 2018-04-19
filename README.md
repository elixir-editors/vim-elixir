# vim-elixir

[![Build Status](https://travis-ci.org/elixir-editors/vim-elixir.svg?branch=master)](https://travis-ci.org/elixir-editors/vim-elixir)

[Elixir](http://elixir-lang.org) support for vim. This plugin also adds support
for Elixir's templating language, EEx.

Features included so far:

* Syntax highlighting for Elixir and EEx
* Filetype detection for `.ex`, `.exs` and `.eex` files
* Automatic indentation

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
Plug 'elixir-editors/vim-elixir'

" NeoBundle
NeoBundle 'elixir-editors/vim-elixir'

" Vundle
Plugin 'elixir-editors/vim-elixir'
```

### Manual installation

Run [./manual_install.sh](manual_install.sh) to copy the contents of each directory in the respective directories inside
`~/.vim`.

## `mix format` Integration

We've decided not to include `mix format` integration into `vim-elixir`. If you'd like to set it up yourself, you have the following options:

* For asynchronous execution of the formatter, have a look at [vim-mix-format](https://github.com/mhinz/vim-mix-format)
* Add it as a `formatprg` (e.g. `set formatprg=mix\ format\ -`)

## Development

To run the tests you can run `bundle exec parallel_rspec spec`

To spawn an interactive Vim instance with the configs from this repo use `bin/spawn_vim`
