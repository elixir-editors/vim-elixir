# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting pipeline' do
  it 'using multiline pipeline' do
    expect(<<~EOF).to be_elixir_indentation
    "a,b,c,d"
    |> String.split(",")
    |> Enum.reverse
    EOF
  end

  it 'attribuition using multline pipeline operator' do
    expect(<<~EOF).to be_elixir_indentation
    [ h | t ] = "a,b,c,d"
                |> String.split(",")
                |> Enum.reverse
    EOF
  end

  it 'function with pipeline operator' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      [ h | t ] = "a,b,c,d"
                  |> String.split(",")
                  |> Enum.reverse

      { :ok, h }
    end
    EOF
  end

  it 'do not breaks on `==`' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      my_post = Post
                |> where([p], p.id == 10)
                |> where([p], u.user_id == 1)
                |> select([p], p)
    end
    EOF
  end

  it 'pipeline operator with block open' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      "a,b,c,d"
      |> String.split(",")
      |> Enum.first
      |> case do
        "a" -> "A"
        _ -> "Z"
      end
    end
    EOF
  end

  it 'using a record with pipeline' do
    expect(<<~EOF).to be_elixir_indentation
    defrecord RECORD, field_a: nil, field_b: nil

    rec = RECORD.new
          |> IO.inspect
    EOF
  end

  it 'indents pipelines with blocks and symbols' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule MyMod do
      def export_info(users) do
        {:ok, infos} = users
                       |> Enum.map(fn (u) -> do_something(u) end)
                       |> Enum.map(fn (u) ->
                         do_even_more(u)
                       end)
                       |> finall_thing

        infos
      end
    end
    EOF
  end

  it 'correctly indents pipelines on a string with "=" embedded in it' do
    expect(<<~EOF).to be_elixir_indentation
    def build_command(input, output) do
      "embedded=here"
      |>
    end
    EOF
  end

  it 'correctly indents pipelines on a charlist with "=" embedded in it' do
    expect(<<~EOF).to be_elixir_indentation
    def build_command(input, output) do
      'embedded=here'
      |>
    end
    EOF
  end

  it 'correctly indents pipelines on a map with "=>" syntax' do
    expect(<<~EOF).to be_elixir_indentation
    def build_command(input, output) do
      %{:hello => :world}
      |>
    end
    EOF
  end

  %w(<= >= == != === !== =~).each do |op|
    it "ignores indents with #{op}" do
      expect(<<~EOF).to be_elixir_indentation
      def build_command(input, output) do
        true #{op} false
        |> IO.inspect
      end
      EOF
    end
  end

  it 'resets the indent after a blank new line' do
    expect(<<~EOF).to be_elixir_indentation
      upcased_names = names
                      |> Enum.map(fn name ->
                        String.upcase(name)
                      end)

      IO.inspect names
    EOF
  end

  it 'resets the indent after a blank line pt. 2' do
    expect(<<~EOF).to be_elixir_indentation
      upcased_names = names
                      |> Enum.map(fn name ->
                        String.upcase(name) end)

      IO.inspect names
    EOF
  end

  it 'keeps indent after a blank if current starts with pipe' do
    expect(<<~EOF).to be_elixir_indentation
      upcased_names = names
                      |> Enum.map(fn name ->
                        String.upcase(name)
                      end)

                      |> do_stuff
    EOF
  end

  i <<~EOF
  def hello do
    do_something
    |> Pipe.to_me
    {:ok}
  end
  EOF

  i <<~EOF
  defmodule MyModule do
    def do_stuff do
      name =
        "Dr. Zaius"
        |> determine_name

      hello
    end
  end
  EOF
end
