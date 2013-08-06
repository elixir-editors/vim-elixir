require 'spec_helper'

describe "Indenting" do
  it "conditional" do
    assert_correct_indenting <<-EOF
      cond do
        foo -> 1
        bar -> 2
      end
    EOF
  end
end
