require 'spec_helper'

describe "Indenting" do
  context "documentation" do
    it "with end keyword" do
      assert_correct_indenting <<-EOF
        defmodule Test do
          @doc """
          end
          """
        end
      EOF
    end
  end
end
