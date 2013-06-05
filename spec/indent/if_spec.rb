require 'spec_helper'

describe "Indenting" do
  it "if-clauses" do
    assert_correct_indenting <<-EOF
      if foo do
        bar
      end
    EOF
  end

  it "if-else-clauses" do
    assert_correct_indenting <<-EOF
      if foo do
        bar
      else
        baz
      end
    EOF
  end
end
