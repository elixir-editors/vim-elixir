# frozen_string_literal: true

require 'spec_helper'

describe 'Heredoc syntax' do
  describe 'binary' do
    it 'with multiline content' do
      expect(<<~EOF).to include_elixir_syntax('elixirDocString', 'foo')
        @doc """
        foo
        """
      EOF
    end

    it 'escapes quotes unless only preceded by whitespace' do
      expect(<<~EOF).to include_elixir_syntax('elixirDocString', %q(^\s*\zs"""))
        @doc """
        foo """
        """
      EOF
    end

    it 'with interpolation' do
      expect(<<~EOF).to include_elixir_syntax('elixirInterpolation', 'bar')
        @doc """
        foo \#{bar}
        """
      EOF
    end

    pending 'interpolation in heredoc must be string' do
      expect(<<~EOF).to include_elixir_syntax('elixirInterpolation', 'test')
      def test do
        """
        foo "test"
        """
      end
      EOF
    end

    pending 'interpolation in heredoc' do
      expect(<<~EOF).to include_elixir_syntax('elixirInterpolation', 'test')
      def test do
        """
        foo "#{test}"
        """
      end
      EOF
    end

    pending 'interpolation in string in heredoc' do
      expect(<<~EOF).to include_elixir_syntax('elixirInterpolation', 'test')
      def test do
        """
        foo #{test}
        """
      end
      EOF
    end
  end
end
