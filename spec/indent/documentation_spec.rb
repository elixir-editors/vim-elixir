# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting documentation' do
  i <<~EOF
  defmodule Test do
    @doc """
    end
    """
  end
  EOF
end
