# frozen_string_literal: true

require 'spec_helper'

describe 'Guard syntax' do
  it 'guard in function' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    def fun(a) when is_atom(a) do
    end
    EOF
  end

  it 'guard in case' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    case
      a when is_atom(a) -> {:ok, a}
    end
    EOF
  end

  it 'does not highlight outside guards' do
    expect(<<~EOF).not_to include_elixir_syntax('elixirKernelFunction', 'is_atom')
      if is_atom(a) do
        {:ok, a}
      end
    EOF
  end
end
