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
end
