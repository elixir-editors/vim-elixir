require 'spec_helper'

describe "Variable syntax" do
  it "unused" do
    assert_correct_syntax 'elixirUnusedVariable', '_from', <<-EOF
      def handle_call(:pop, _from, [h|stack]) do
        { :reply, h, stack }
      end
    EOF
  end
end
