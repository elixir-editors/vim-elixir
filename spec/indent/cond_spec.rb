require 'spec_helper'

describe 'Indenting' do
  it 'conditional' do
    expect(<<-EOF).to be_elixir_indentation
      cond do
        foo -> 1
        bar -> 2
      end
    EOF
  end
end
