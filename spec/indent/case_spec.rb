require 'spec_helper'

describe 'Indenting' do
  specify 'case statements' do
    expect(<<-EOF).to be_elixir_indentation
      case some_function do
        :ok ->
          :ok
        { :error, :message } ->
          { :error, :message }
      end
    EOF
  end
end
