# frozen_string_literal: true

require 'spec_helper'

describe 'ExUnit syntax' do
  it 'test macro' do
    expect(<<~EOF).to include_elixir_syntax('elixirExUnitMacro', 'test')
    test 'that stuff works' do
      assert true
    end
    EOF
  end

  it 'describe macro' do
    expect(<<~EOF).to include_elixir_syntax('elixirExUnitMacro', 'describe')
    describe 'some_function/1' do
      test 'that stuff works' do
        assert true
      end
    end
    EOF
  end
end
