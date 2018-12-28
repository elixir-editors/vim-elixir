# frozen_string_literal: true

require 'spec_helper'

describe 'function indenting' do
  i <<~EOF
    def hello_world do
      hello
    rescue
      _ ->
        IO.puts("hello")
    end
  EOF
end
