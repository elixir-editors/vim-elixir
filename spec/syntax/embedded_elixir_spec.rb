# frozen_string_literal: true

require 'spec_helper'

describe 'Embedded Elixir syntax' do
  it 'elixir' do
    expect('<%= if true do %>').to include_eelixir_syntax('elixirKeyword', 'if')
    expect('<%= if true do %>').to include_eelixir_syntax('elixirBoolean', 'true')
  end

  it 'expression' do
    expect('<%= if true do %>').to include_eelixir_syntax('eelixirExpression', 'if')
    expect('<% end %>').to include_eelixir_syntax('eelixirExpression', 'end')
  end

  it 'quote' do
    expect('<%% def f %>').to include_eelixir_syntax('eelixirQuote', 'def')
  end

  it 'comment' do
    expect('<%# foo bar baz %>').to include_eelixir_syntax('eelixirComment', 'foo')
  end

  it 'delimiters' do
    expect('<% end %>').to include_eelixir_syntax('eelixirDelimiter', '<%')
    expect('<% end %>').to include_eelixir_syntax('eelixirDelimiter', '%>')
  end
end
