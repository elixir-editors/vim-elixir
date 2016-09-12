# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting if clauses' do
  it 'if..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    if foo do
      bar
    end
    EOF
  end

  it 'if..do..else..end' do
    expect(<<~EOF).to be_elixir_indentation
    if foo do
      bar
    else
      baz
    end
    EOF
  end

  it 'does not indent keywords in strings' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      "else"
    end
    EOF
  end
end
