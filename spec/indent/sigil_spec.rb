# frozen_string_literal: true

require 'spec_helper'

describe 'Basic indenting' do
  i <<~EOF
  r = ~r"with"
  waaaaaaa
  EOF
end
