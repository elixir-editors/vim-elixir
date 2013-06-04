require 'spec_helper'

describe "Indenting" do
  specify "'do' indenting" do
    assert_correct_indenting <<-EOF
      do
        something
      end
    EOF
  end
end
