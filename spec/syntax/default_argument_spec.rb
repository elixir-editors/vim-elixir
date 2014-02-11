require 'spec_helper'

describe "Default argument syntax" do
  it "default argument" do
    assert_correct_syntax 'elixirOperator', '\\', <<-'EOF'
      def foo(bar \\ :baz)
    EOF

    assert_correct_syntax 'elixirOperator', '\/', <<-EOF
      def foo(bar // :baz)
    EOF
  end
end
