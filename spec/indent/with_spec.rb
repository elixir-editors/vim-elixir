# frozen_string_literal: true

require 'spec_helper'

describe 'with' do
  i <<~EOF
  with {:ok, msg} <- Msgpax.unpack(payload) do
    {:ok, rebuild(msg)}
  else
    error -> error
  end
  EOF

  it 'with..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    with {:ok, width} <- Map.fetch(opts, :width),
         double_width = width * 2,
         {:ok, height} <- Map.fetch(opts, :height)
    do
      {:ok, double_width * height}
    end
    EOF
  end

  it 'with..do:' do
    expect(<<~EOF).to be_elixir_indentation
      with {:ok, width} <- Map.fetch(opts, :width),
           double_width = width * 2,
           {:ok, height} <- Map.fetch(opts, :height),
        do: {:ok, double_width * height}
    EOF
  end

  it 'with..do..else..end' do
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

  it 'with..,do:..,else:..' do
    expect(<<~EOF).to be_elixir_indentation
    with {:ok, width} <- Map.fetch(opts, :width),
         {:ok, height} <- Map.fetch(opts, :height),
      do:
        {:ok, width * height},
      else:
        (:error -> {:error, :wrong_data})
    EOF
  end

  i <<~'EOF'
    # This file is responsible for configuring your application
    # and its dependencies with the aid of the Mix.Config module.
    use Mix.Config

    import_config "#{Mix.env}.exs"
  EOF
end
