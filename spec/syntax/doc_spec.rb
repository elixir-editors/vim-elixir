# frozen_string_literal: true

require 'spec_helper'

describe 'documentation syntax' do
  describe 'string' do
    it 'doc in double quotes' do
      expect('@doc "foo"').to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc in sigil_S' do
      expect('@doc ~S(foo)').to include_elixir_syntax('elixirDocString', 'foo')
    end
  end

  describe 'heredoc' do
    it 'doc with multiline content' do
      ex = <<~EOF
        @callbackdoc """
        foo
        """
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with sigil_S triple double-quoted multiline content' do
      ex = <<~EOF
        @doc ~S"""
        foo
        """
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirSigilDelimiter', 'S"""')
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with sigil_S triple single-quoted multiline content' do
      ex = <<~EOF
        @doc ~S'''
        foo
        '''
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirSigilDelimiter', "S'''")
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with triple single-quoted multiline content is not a doc string' do
      ex = <<~EOF
        @doc '''
        foo
        '''
      EOF
      expect(ex).not_to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with interpolation' do
      ex = <<~EOF
        @doc """
        foo \#{bar}
        """
      EOF
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
      expect(ex).to include_elixir_syntax('elixirStringDelimiter', '"""')
      expect(ex).to include_elixir_syntax('elixirInterpolation', 'bar')
    end
  end
end
