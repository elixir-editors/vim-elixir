# vim-elixir

[![Build Status](https://travis-ci.org/elixir-lang/vim-elixir.png?branch=master)](https://travis-ci.org/elixir-lang/vim-elixir)

This project contains some Vim configuration files to work with [Elixir](http://elixir-lang.org).

So far it's included:

* Syntax highlighting

* Filetype detection

* Auto indentation

## Install

* Copy the files to your `~/.vim` directory.

* If you use vim-pathogen you can clone this repo into `~/.vim/bundle`

## Snippets

If you are looking for snipmate snippets take a look at: [elixir-snippets](https://github.com/carlosgaldino/elixir-snippets)

---

> :warning: **Warning:** Older versions (`<= 3.4.0-106`) of Syntastic check Elixir scripts *by executing them*. In addition to
> being unsafe, this can cause Vim to hang while saving Elixir scripts. This is not an error in `vim-elixir`. [The issue is
> remedied in Syntastic](https://github.com/scrooloose/syntastic/commit/1d19dff701524ebed90a4fbd7c7cd75ab954b79d) by 
> disabling Elixir checking by default.
> 
> **If your version of Syntastic is below `3.4.0-107` (16 July 2014), you should update to a newer version.**

---
