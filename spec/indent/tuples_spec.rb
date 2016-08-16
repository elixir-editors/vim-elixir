require 'spec_helper'

describe 'Indenting' do
  specify 'multiline tuple' do
    expect(<<-EOF).to be_elixir_indentation
    def xpto do
      { :a,
        :b,
        :c }
    end
    EOF
  end

  specify 'tuples with break line after square brackets' do
    expect(<<-EOF).to be_elixir_indentation
    def method do
      {
        :bar,
        path: "deps/umbrella/apps/bar"
      }
    end
    EOF
  end
end
