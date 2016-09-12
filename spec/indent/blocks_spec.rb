# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting blocks' do
  it "'do' indenting" do
    expect(<<~EOF).to be_elixir_indentation
    do
      something
    end
    EOF
  end

  it 'does not consider :end as end' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Test do
      def lol do
        IO.inspect :end
      end
    end
    EOF
  end

  it 'does not consider do: as the start of a block' do
    expect(<<~EOF).to be_elixir_indentation
    def f do
      if true, do: 42
    end
    EOF
  end

  it "do not mislead atom ':do'" do
    expect(<<~EOF).to be_elixir_indentation
    def f do
      x = :do
    end
    EOF
  end

  it 'multiline assignment' do
    expect(<<~EOF).to be_elixir_indentation
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

  describe 'with' do
    pending 'with..do..end' do
      expect(<<~EOF).to be_elixir_indentation
      with {:ok, width} <- Map.fetch(opts, :width),
           double_width = width * 2,
           {:ok, height} <- Map.fetch(opts, :height)
      do
        {:ok, double_width * height}
      end
      EOF
    end

    pending 'with..,do:' do
      expect(<<~EOF).to be_elixir_indentation
      with {:ok, width} <- Map.fetch(opts, :width),
          double_width = width * 2,
          {:ok, height} <- Map.fetch(opts, :height),
        do: {:ok, double_width * height}
      EOF
    end

    pending 'with..do..else..end' do
      expect(<<~EOF).to be_elixir_indentation
      with {:ok, width} <- Map.fetch(opts, :width),
           {:ok, height} <- Map.fetch(opts, :height)
      do
        {:ok, width * height}
      else
        :error ->
          {:error, :wrong_data}
      end
      EOF
    end

    pending 'with..,do:..,else:..' do
      expect(<<~EOF).to be_elixir_indentation
      with {:ok, width} <- Map.fetch(opts, :width),
           {:ok, height} <- Map.fetch(opts, :height),
        do:
          {:ok, width * height},
        else:
          (:error -> {:error, :wrong_data})
      end
      EOF
    end
  end
end
