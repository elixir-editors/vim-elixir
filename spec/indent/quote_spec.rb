# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting quote statements' do
  i <<~EOF
  defmacro foo do
    quote do
      unquote(foo)
    end
  end
  EOF

  i <<~EOF
  defmacro foo do
    if 1 = 1 do
      quote do
        unquote(foo)
      end
    end
  end
  EOF
end
