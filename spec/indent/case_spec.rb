# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting case statements' do
  it 'case..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    case some_function do
      :ok ->
        :ok
      { :error, :message } ->
        { :error, :message }
    end
    EOF
  end

  pending 'with long bodies' do
    expect(<<~EOF).to be_elixir_indentation
    decoded_msg = case JSON.decode(msg) do
      {:error, _} ->
        "a"
        "dasdas"
        "dsadas"
      {:ok, decoded} -> decoded
    end
    EOF
  end
end
