require 'spec_helper'

describe "Indenting" do
  specify "'do' indenting" do
    assert_correct_indenting <<-EOF
      do
        something
      end
    EOF
  end

  it "does not consider :end as end" do
    assert_correct_indenting <<-EOF
      defmodule Test do
        def lol do
          IO.inspect :end
        end
      end
    EOF
  end
end
