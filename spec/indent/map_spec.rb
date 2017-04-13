# frozen_string_literal: true

require 'spec_helper'

describe 'Map indent' do
  it 'maps in funcs' do
    expect(<<~'EOF').to be_elixir_indentation
    DrMock.mock(fn ->
      params = %{

      }
    end)
    EOF
  end

  i <<~EOF
  x = %{
    foo: :bar
  }

  y = :foo
  EOF

  i <<~EOF
  x =
    %{ foo: :bar }

  y = :foo
  EOF

  i <<~EOF
  x = %{
    foo: :bar }

  y = :foo
  EOF

  i <<~EOF
  test "test" do
    Mod.fun(fn ->
      map = %Mod.Map{
        id: "abc123",
        state: "processing",
        submod: %Mod.Submod{
          options: %{}
        }
      }
  EOF
end
