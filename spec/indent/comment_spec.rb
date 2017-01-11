# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting *after* comments' do
  it 'commented "do" should not cause next line to indent' do
    expect(<<~EOF).to be_elixir_indentation
    # do
    IO.puts :test
    EOF
  end
end

