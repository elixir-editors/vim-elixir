# frozen_string_literal: true

require 'spec_helper'

describe 'Guard syntax' do
  it 'guard in function' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    def fun(a) when is_atom(a), do:
    EOF
  end

  it 'guard in if' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    if is_atom(:atom), do: true
    EOF
  end

  it 'guard in case' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    case true do
      true when is_atom(:atom) -> true
    end
    EOF
  end

  it 'guard in case (multiline)' do
    expect(<<~EOF).to include_elixir_syntax('elixirKernelFunction', 'is_atom')
    case true do
      true when is_boolean(true) and
      is_atom(:atom) -> true
    end
    EOF
  end
end
