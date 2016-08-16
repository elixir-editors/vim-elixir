require 'spec_helper'

describe 'Indenting' do
  it 'using multiline pipeline' do
    expect(<<-EOF).to be_elixir_indentation
    "a,b,c,d"
    |> String.split(",")
    |> Enum.reverse
    EOF
  end

  it 'attribuition using multline pipeline operator' do
    expect(<<-EOF).to be_elixir_indentation
    [ h | t ] = "a,b,c,d"
                |> String.split(",")
                |> Enum.reverse
    EOF
  end

  it 'function with pipeline operator' do
    expect(<<-EOF).to be_elixir_indentation
    def test do
      [ h | t ] = "a,b,c,d"
                  |> String.split(",")
                  |> Enum.reverse

      { :ok, h }
    end
    EOF
  end

  it 'do not breaks on `==`' do
    expect(<<-EOF).to be_elixir_indentation
    def test do
      my_post = Post
                |> where([p], p.id == 10)
                |> where([p], u.user_id == 1)
                |> select([p], p)
    end
    EOF
  end

  it 'pipeline operator with block open' do
    expect(<<-EOF).to be_elixir_indentation
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
    expect(<<-EOF).to be_elixir_indentation
    defrecord RECORD, field_a: nil, field_b: nil

    rec = RECORD.new
          |> IO.inspect
    EOF
  end
end
