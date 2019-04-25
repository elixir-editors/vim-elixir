# vim-elixir

[![Build Status](https://travis-ci.org/elixir-editors/vim-elixir.svg?branch=master)](https://travis-ci.org/elixir-editors/vim-elixir)

[Elixir](http://elixir-lang.org) support for vim

## Description

Features:

* Syntax highlighting for Elixir and EEx files
* Filetype detection for `.ex`, `.exs`, `.eex` and `.leex` files
* Automatic indentation
* Integration between Ecto projects and [vim-dadbod][] for running SQL queries
  on defined Ecto repositories

## Installation

### Plugin Managers

```bash
# vim 8 native package loading
# http://vimhelp.appspot.com/repeat.txt.html#packages
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/pack/my-packages/start/vim-elixir
```

```bash
# pathogen
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir
```

```viml
" vim-plug
Plug 'elixir-editors/vim-elixir'

" Vundle
Plugin 'elixir-editors/vim-elixir'

" NeoBundle
NeoBundle 'elixir-editors/vim-elixir'
```

### Manual installation

Run [./manual_install.sh](manual_install.sh) to copy the contents of each directory in the respective directories inside
`~/.vim`.

## `mix format` Integration

We've decided not to include `mix format` integration into `vim-elixir`. If you'd like to set it up yourself, you have the following options:

* For asynchronous execution of the formatter, have a look at [vim-mix-format](https://github.com/mhinz/vim-mix-format)
* Add it as a `formatprg` (e.g. `set formatprg=mix\ format\ -`)

## Development

Run the tests: `bundle exec parallel_rspec spec`

Spawn a container with vim and dev configs: `docker-compose build && docker-compose run vim`

[vim-dadbod]: https://github.com/tpope/vim-dadbod
