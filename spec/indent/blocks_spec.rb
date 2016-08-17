require 'spec_helper'

describe 'Indenting' do
  specify "'do' indenting" do
    expect(<<-EOF).to be_elixir_indentation
      do
        something
      end
    EOF
  end

  it 'does not consider :end as end' do
    expect(<<-EOF).to be_elixir_indentation
      defmodule Test do
        def lol do
          IO.inspect :end
        end
      end
    EOF
  end

  it 'does not consider do: as the start of a block' do
    expect(<<-EOF).to be_elixir_indentation
      def f do
        if true, do: 42
      end
    EOF
  end

  it "do not mislead atom ':do'" do
    expect(<<-EOF).to be_elixir_indentation
      def f do
        x = :do
      end
    EOF
  end

  it 'multiline assignment' do
    expect(<<-EOF).to be_elixir_indentation
    defmodule Test do
      def test do
        one =
          user
          |> build_assoc(:videos)
          |> Video.changeset()

        other =
          user2
          |> build_assoc(:videos)
          |> Video.changeset()
      end
    end
    EOF
  end
end
