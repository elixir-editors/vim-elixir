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
      ex = <<~'EOF'
        @callbackdoc """
        foo
        """
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with sigil_S triple double-quoted multiline content' do
      ex = <<~'EOF'
        @doc ~S"""
        foo
        """
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirSigilDelimiter', 'S"""')
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with sigil_S triple single-quoted multiline content' do
      ex = <<~'EOF'
        @doc ~S'''
        foo
        '''
      EOF
      expect(ex).to include_elixir_syntax('elixirVariable', 'doc')
      expect(ex).to include_elixir_syntax('elixirSigilDelimiter', "S'''")
      expect(ex).to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc with triple single-quoted multiline content is not a doc string' do
      ex = <<~'EOF'
        @doc '''
        foo
        '''
      EOF
      expect(ex).not_to include_elixir_syntax('elixirDocString', 'foo')
    end

    it 'doc skip interpolation' do
      ex = <<~'EOF'
        @doc """
        foo #{bar}
        """
      EOF
      expect(ex).to     include_elixir_syntax('elixirDocString',       'foo')
      expect(ex).to     include_elixir_syntax('elixirStringDelimiter', '"""')
      expect(ex).not_to include_elixir_syntax('elixirInterpolation',   'bar')
    end

    it 'doc with doctest' do
      ex = <<~'EOF'
      @doc """
      doctest

      iex> Enum.map [1, 2, 3], fn(x) ->
      ...>   x * 2
      ...> end
      [2, 4, 6]

      """
      EOF
      expect(ex).to include_elixir_syntax('elixirDocString', 'doctest')
      expect(ex).to include_elixir_syntax('elixirDocTest',   'map')
      expect(ex).to include_elixir_syntax('elixirDocTest',   'x * 2')
      expect(ex).to include_elixir_syntax('elixirDocTest',   '2, 4, 6')
    end

    it 'doc with inline code' do
      ex = <<~'EOF'
      @doc """
      doctest with inline code `List.wrap([])`
      """
      EOF
      expect(ex).to include_elixir_syntax('elixirDocString', 'doctest')
      expect(ex).to include_elixir_syntax('elixirDocString',   'wrap')
    end

    describe "use markdown for docs" do
      before(:each) { VIM.command("let g:elixir_use_markdown_for_docs = 1") }

      it 'doc with inline code' do
	ex = <<~'EOF'
	@doc """
	doctest with inline code `List.wrap([])`
	"""
	EOF
	expect(ex).to include_elixir_syntax('elixirDocString', 'doctest')
	expect(ex).to include_elixir_syntax('markdownCode',   'wrap')
      end
    end
  end
end
