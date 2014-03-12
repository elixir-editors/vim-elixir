require 'spec_helper'

describe "Indenting" do
  specify "multiline tuple" do
    assert_correct_indenting <<-EOF
    def xpto do
      { :a,
        :b,
        :c }
    end
    EOF
  end

  specify "tuples with break line after square brackets" do
    assert_correct_indenting <<-EOF
    def method do
      {
        :bar,
        path: "deps/umbrella/apps/bar"
      }
    end
    EOF
  end
end
