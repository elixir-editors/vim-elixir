require 'spec_helper'

describe 'Indenting' do
  it 'if-clauses' do
    expect(<<-EOF).to be_elixir_indentation
      if foo do
        bar
      end
    EOF
  end

  it 'if-else-clauses' do
    expect(<<-EOF).to be_elixir_indentation
      if foo do
        bar
      else
        baz
      end
    EOF
  end
end
