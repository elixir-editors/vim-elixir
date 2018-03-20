# frozen_string_literal: true

require 'spec_helper'

describe 'Keyword syntax' do
  it 'for used as keyword' do
    expect(<<~EOF).to include_elixir_syntax('elixirKeyword', 'for')
    for v <- [1, 3, 3]
    EOF
  end

  it 'case used as keyword' do
    expect(<<~EOF).to include_elixir_syntax('elixirKeyword', 'case')
    case true do
    EOF
  end

  it 'length' do
    expect(<<~EOF).not_to include_elixir_syntax('elixirKeyword', 'length')
    assert String.length(captured) > 0
    EOF

    expect(<<~EOF).not_to include_elixir_syntax('elixirKeyword', 'size')
    assert String.size(captured) > 0
    EOF

    expect(<<~EOF).to include_elixir_syntax('elixirKeyword', 'length')
    assert length(captured) > 0
    EOF
  end
end
