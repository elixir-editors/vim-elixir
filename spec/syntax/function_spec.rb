
# frozen_string_literal: true

require 'spec_helper'

describe 'function syntax' do
  it 'doesnt treat underscored functions like unsued variables' do
    expect(<<~EOF).to include_elixir_syntax('elixirId', '__ensure_defimpl__')
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

  it 'detects function calls with parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      func()
    EOF
  end

  it 'detects function calls appended by module without parenthesis' do
    expect(<<~'EOF').to include_elixir_syntax('elixirFunctionCall', 'func')
      Mod.func
    EOF
  end
end
