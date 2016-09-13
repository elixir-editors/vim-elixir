# frozen_string_literal: true

require 'spec_helper'

describe 'Comments syntax' do
  it 'full line comment' do
    expect(<<~EOF).to include_elixir_syntax('elixirComment', '#\ this\ is\ a\ comment')
    # this is a comment
    EOF
  end

  it 'end line comment' do
    expect(<<~EOF).to include_elixir_syntax('elixirComment', '#\ this\ is\ a\ comment')
    IO.puts "some text" # this is a comment
    EOF
  end
end
