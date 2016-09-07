# frozen_string_literal: true

require 'spec_helper'

describe 'Struct syntax' do
  it 'without defaults' do
    expect(<<~EOF).to include_elixir_syntax('elixirAtom', ':name')
      defstruct [:name, :age]
    EOF
  end

  it 'with defaults' do
    expect(<<~EOF).to include_elixir_syntax('elixirAtom', 'name:')
      defstruct name: "john", age: 27
    EOF
  end
end
