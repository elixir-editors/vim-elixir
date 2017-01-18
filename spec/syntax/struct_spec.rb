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

  it 'structs' do
    str = %q(%MyStruct{name: "josh"})

    expect(str).to include_elixir_syntax('elixirStructStartDelimiter', '%')
    expect(str).to include_elixir_syntax('elixirStruct', '%')

    expect(str).to include_elixir_syntax('elixirAlias', 'MyStruct')
    expect(str).to include_elixir_syntax('elixirStruct', 'MyStruct')

    expect(str).to include_elixir_syntax('elixirStructBodyDelimiter', '{')
    expect(str).to include_elixir_syntax('elixirStruct', '{')

    expect(str).to include_elixir_syntax('elixirAtom', 'name:')
    expect(str).to include_elixir_syntax('elixirStruct', 'name:')
    expect(str).to include_elixir_syntax('elixirStructBody', 'name:')

    expect(str).to include_elixir_syntax('elixirStructBodyDelimiter', '}')
    expect(str).to include_elixir_syntax('elixirStruct', '}')
  end
end
