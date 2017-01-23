# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting tuples' do
  it 'multiline tuple' do
    expect(<<~EOF).to be_elixir_indentation
    def xpto do
      { :a,
        :b,
        :c }
    end
    EOF
  end

  it 'tuples with break line after square brackets' do
    expect(<<~EOF).to be_elixir_indentation
    def method do
      {
        :bar,
        path: "deps/umbrella/apps/bar"
      }
    end
    EOF
  end

  it 'tuples with strings with embedded braces' do
    expect(<<~EOF).to be_elixir_indentation
    x = [
      {:text, "asd {"},
      {:text, "qwe"},
    ]
    EOF
  end
end
