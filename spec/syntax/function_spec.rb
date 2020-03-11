
# frozen_string_literal: true

require 'spec_helper'

describe 'function syntax' do
  it 'doesnt treat underscored functions like unsued variables' do
    expect(<<~EOF).to include_elixir_syntax('elixirFunctionCall', '__ensure_defimpl__')
      defp derive(protocol, for, struct, opts, env) do
        # ... code ...
        __ensure_defimpl__(protocol, for, env)
    EOF

    expect(<<~EOF).not_to include_elixir_syntax('elixirUnusedVariable', '__ensure_defimpl__')
      defp derive(protocol, for, struct, opts, env) do
        # ... code ...
        __ensure_defimpl__(protocol, for, env)
    EOF
  end

  it 'matches top-level macros as elixirKeyword' do
    expect(<<~EOF).to include_elixir_syntax('elixirKeyword', 'quote')
      quote do
        # ... code ...
      end
    EOF

    expect(<<~EOF).to include_elixir_syntax('elixirKeyword', 'quote')
      quote(do: '')
    EOF
  end

  it 'detects higher order function calls' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func.()
    EOF
  end

  it 'detects function calls with parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func()
    EOF
  end

  it 'detects function calls with bangs' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func!')
      func!()
    EOF
  end

  it 'detects function calls with question marks' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func?')
      func?()
    EOF
  end

  it 'detects function calls appended by module with parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      Mod.func()
    EOF
  end

  it 'detects function calls appended by atom with parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      :mod.func()
    EOF
  end

  it 'detects function calls appended by module without parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      Mod.func
    EOF
  end

  it 'detects function calls appended by atom without parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      :mod.func
    EOF
  end

  it 'detects function calls without parenthesis that contain paramenters' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func 1
    EOF
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func [1]
    EOF
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func :atom
    EOF
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func "string"
    EOF
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func 'a'
    EOF
  end

  it 'does not highlight function calls without parenthesis that does not contain paramenters' do
    expect(<<~'EOF').not_to include_elixir_syntax('elixirFunctionCall', 'func')
      func
    EOF
  end

  it 'does not detect calls to function with invalid names' do
    expect(<<~'EOF').not_to include_elixir_syntax('elixirFunctionCall', '2fast2func')
      2fast2func()
    EOF
  end

  it 'ignores spacing between module and function names' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      Module .           func
    EOF
  end

  it 'detects piped functions with parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      one_func()
      |> func()
    EOF
  end

  it 'detects piped functions without parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      one_func()
      |> func
    EOF
  end
end
