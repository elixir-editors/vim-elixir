# frozen_string_literal: true

require 'spec_helper'

describe 'String syntax' do
  describe 'binary' do
    it 'double quoted string' do
      expect('foo "test"').to include_elixir_syntax('elixirString', 'test')
    end

    it 'double quoted string with escaped quote' do
      expect('"this \"test is all one string"').to include_elixir_syntax('elixirString', 'test')
    end

    it 'charlist with escaped quote' do
      expect(<<-'EOF').to include_elixir_syntax('elixirString', 'test')
        'this \'test is all one charlist'
      EOF
    end

    it 'interpolation in string' do
      expect('do_something "foo #{test}"').to include_elixir_syntax('elixirInterpolation', 'test')
    end
  end
end
