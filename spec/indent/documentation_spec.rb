# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting documentation' do
  it 'with end keyword' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Test do
      @doc """
      end
      """
    end
    EOF
  end
end
