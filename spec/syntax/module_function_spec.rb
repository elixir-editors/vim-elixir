# frozen_string_literal: true

require 'spec_helper'

describe 'Module function syntax' do
  it 'for used as module function' do
    expect(<<~EOF).to include_elixir_syntax('elixirFunctionCall', 'for')
    OverridesDefault.for
    EOF
  end

  it 'case used as module function' do
    expect(<<~EOF).to include_elixir_syntax('elixirFunctionCall', 'case')
    OverridesDefault.case
    EOF
  end
end
