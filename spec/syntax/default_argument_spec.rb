# frozen_string_literal: true

require 'spec_helper'

describe 'Default argument syntax' do
  it 'default argument' do
    expect(<<~'EOF').to include_elixir_syntax('elixirOperator', '\\')
      def foo(bar \\ :baz)
    EOF

    expect(<<~EOF).to include_elixir_syntax('elixirOperator', '\/')
      def foo(bar // :baz)
    EOF
  end
end
