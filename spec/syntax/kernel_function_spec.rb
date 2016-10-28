# frozen_string_literal: true

require 'spec_helper'

describe 'Kernel function syntax' do
  it 'kernel function used as an atom key in a keyword list contained in a block' do
    expect(<<~EOF).not_to include_elixir_syntax('elixirKernelFunction', 'length')
    do
      plug Plug.Parsers,
        parsers: [:urlencoded, :multipart, :json],
        pass: ["*/*"],
        json_decoder: Poison,
        length: 400_000_000
    EOF
  end

  it 'kernel function used as a guard' do
    expect(<<~'EOF').to include_elixir_syntax('elixirKernelFunction', 'length')
    def hello(name) when length(name) > 20 do
      IO.puts "hello #{name}, you big boy"
    end
    EOF
  end

  it 'kernel function used in a function body' do
    expect(<<~'EOF').not_to include_elixir_syntax('elixirKernelFunction', 'length')
    def say_size(chars) do
      size = length(chars)
      IO.puts "you gave me #{size} chars"
    end
    EOF
  end

  it 'kernel function used as top-level' do
    expect(<<~'EOF').not_to include_elixir_syntax('elixirKernelFunction', 'length')
    length(chars)
    EOF
  end
end
