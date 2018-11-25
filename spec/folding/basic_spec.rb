# frozen_string_literal: true

require 'spec_helper'

describe 'Basic folding' do
  def self.it_folds_lines(content, lines, tags = nil)
    it("folds #{lines} lines on \n#{content}", tags) do
      expect(content).to fold_lines(lines, tags)
    end
  end

  it_folds_lines(<<~EOF, 2)
  defmodule M do
  end
  EOF
end

