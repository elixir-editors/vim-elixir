# frozen_string_literal: true

require 'spec_helper'

describe 'Heredoc syntax' do
  describe 'binary' do
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

    it 'interpolation in heredoc must be string' do
      expect(<<~EOF).to include_elixir_syntax('elixirString', 'test')
      def function do
        """
        foo "test"
        """
      end
      EOF
    end

    it 'interpolation in heredoc' do
      expect(<<~'EOF').to include_elixir_syntax('elixirInterpolation', '#{')
      def function do
        """
        foo "#{test}"
        """
      end
      EOF
    end

    it 'interpolation in string in heredoc' do
      expect(<<~'EOF').to include_elixir_syntax('elixirInterpolation', '#{')
      def function do
        """
        foo #{test}
        """
      end
      EOF
    end
  end
end
