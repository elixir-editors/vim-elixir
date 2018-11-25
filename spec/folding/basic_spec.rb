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
  "not in fold"
  EOF

  it_folds_lines(<<~EOF, 4)
  defmodule M do
    def some_func do
    end
  end
  "not in fold"
  EOF

  it_folds_lines(<<~EOF, 2, on_line: 2)
  defmodule M do
    def some_func do
    end
  end
  "not in fold"
  EOF

  it_folds_lines(<<~EOF, 2)
  if true do
  end
  "not in fold"
  EOF

  it_folds_lines(<<~EOF, 3, on_line: 3)
  if true do
    nil
  else
    nil
  end
  "not in fold"
  EOF

  it_folds_lines(<<~EOF, 5, skip: "broken")
  if true do
    nil
  else
    nil
  end
  "not in fold"
  EOF
end

