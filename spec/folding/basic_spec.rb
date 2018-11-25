# frozen_string_literal: true

require 'spec_helper'

RSpec::Matchers.define :fold_lines do |lines|
  file = ".fixture.ex"


  match do |code|
    File.write(file, code)
    VIM.edit file
    VIM.command("set foldmethod=syntax")

    VIM.normal("zO")
    VIM.normal("zM")
    VIM.normal("dd")
    VIM.write

    written = IO.read(file)
    code.lines.count - written.lines.count == lines
  end
end

describe 'Basic folding' do
  it 'blah' do
    content = <<~EOF
    defmodule M do
    end
    EOF

    expect(content).to fold_lines(2)
  end
end

