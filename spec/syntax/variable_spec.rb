require 'spec_helper'

describe 'Variable syntax' do
  it 'unused' do
    expect(<<-EOF).to include_elixir_syntax('elixirUnusedVariable', '_from')
      def handle_call(:pop, _from, [h|stack]) do
        { :reply, h, stack }
      end
    EOF
  end
end
