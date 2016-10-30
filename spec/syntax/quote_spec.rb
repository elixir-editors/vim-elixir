# frozen_string_literal: true

require 'spec_helper'

describe 'Quote syntax' do
  it 'quote-embedded unquote used to define public function name' do
    expect(<<~EOF).to include_elixir_syntax('elixirUnquoteKeyword', 'unquote')
    defmodule Options do
      defmacro options do
        quote do
          def unquote(name)(_opts) do
            :ok
          end
        end
      end
    end
    EOF
  end

  it 'quote-embedded unquote body' do
    expect(<<~EOF).to include_elixir_syntax('elixirId', 'name')
    defmodule Options do
      defmacro options do
        quote do
          def unquote(name)(_opts) do
            :ok
          end
        end
      end
    end
    EOF
  end

  it 'quote-embedded unquote used to define private function name' do
    expect(<<~EOF).to include_elixir_syntax('elixirUnquoteKeyword', 'unquote')
    defmodule Options do
      defmacro options do
        quote do
          defp unquote(name)(_opts) do
            :ok
          end
        end
      end
    end
    EOF
  end
end
