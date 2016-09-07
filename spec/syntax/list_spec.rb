# frozen_string_literal: true

require 'spec_helper'

describe 'List syntax' do
  it 'should properly handle "\\\\" inside' do
    syntax = <<~EOF
      '"\\\\'
      var = 1
    EOF
    expect(syntax).to include_elixir_syntax('elixirId', 'var')
    expect(syntax).not_to include_elixir_syntax('elixirString', 'var')
  end
end
