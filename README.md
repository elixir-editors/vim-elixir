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

`vim-elixir` can be installed either with a plugin manager or by directly copying the files into your vim folders (location varies between platforms)

### Plugin Managers

If you are using a plugin manager then add `vim-elixir` the way you would any other plugin:

```bash
# Using vim 8 native package loading
#   http://vimhelp.appspot.com/repeat.txt.html#packages
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/pack/my-packages/start/vim-elixir

# Using pathogen
git clone https://github.com/elixir-lang/vim-elixir.git ~/.vim/bundle/vim-elixir
```

```viml
" Using vim-plug
Plug 'elixir-editors/vim-elixir'

" Using Vundle
Plugin 'elixir-editors/vim-elixir'

" Using NeoBundle
NeoBundle 'elixir-editors/vim-elixir'
```

### Manual Installation

If you are not using a package manager then you can use the provided `manual_install.sh` script to copy the files into their respective homes.

Run [./manual_install.sh](manual_install.sh) to copy the contents of each directory in the respective directories inside `~/.vim`.

## Notes/Caveats

### `mix format` Integration

We've decided not to include `mix format` integration into `vim-elixir`.
If you'd like to set it up yourself, you have the following options:

* For asynchronous execution of the formatter, have a look at [vim-mix-format](https://github.com/mhinz/vim-mix-format)
* Add it as a `formatprg` (e.g. `setlocal formatprg=mix\ format\ -`)

Why isn't this supported? We've run into two major issues with calling out to `mix format`.
First `mix format` would not work unless your program compiled.
Second `mix format` added an external process dependency to `vim-elixir`.

If someone really wanted to try and add this then we might be able to model it after `vim-go`'s `go fmt` integration
which I think could be acceptable to merge into master.

## Development

### Maintenance Help

I no longer use Elixir regularly and would love help maintaining this plugin.
If you get a lot of value from it, know vimscript well, or eager to learn about it then feel free to get in touch (GH issue, Elixir Slack, etc)

### Running the Tests

Run the tests: `bundle exec parallel_rspec spec`

Spawn a container with vim and dev configs: `docker-compose build && docker-compose run vim`

[vim-dadbod]: https://github.com/tpope/vim-dadbod
