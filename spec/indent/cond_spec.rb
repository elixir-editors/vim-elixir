# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting cond statements' do
  it 'cond..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    cond do
      foo -> 1
      bar -> 2
    end
    EOF
  end
end
