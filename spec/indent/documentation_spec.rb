require 'spec_helper'

describe 'Indenting' do
  context 'documentation' do
    it 'with end keyword' do
      expect(<<-EOF).to be_elixir_indentation
        defmodule Test do
          @doc """
          end
          """
        end
      EOF
    end
  end
end
