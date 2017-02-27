# frozen_string_literal: true

require 'spec_helper'

describe 'Binary operators' do
  i <<~EOF
  word =
    "h"
    <> "e"
    <> "l"
    <> "l"
    <> "o"

  IO.puts word
  EOF
end
