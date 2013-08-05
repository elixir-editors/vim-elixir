require 'spec_helper'

describe "Indenting" do
  specify "lists" do
    assert_correct_indenting <<-EOF
      def example do
        [ :foo,
          :bar,
          :baz ]
      end
    EOF
  end

  specify "keyword list" do
    assert_correct_indenting <<-EOF
      def project do
        [ name: "mix",
          version: "0.1.0",
          deps: deps ]
      end
    EOF
  end

  specify "keyword" do
    assert_correct_indenting <<-EOF
      def config do
        [ name:
          "John" ]
      end
    EOF
  end
end
