require 'spec_helper'

describe "Indenting" do
  specify "lists" do
    assert_correct_indenting <<-EOF
      def project do
        [name: "mix",
         version: "0.1.0"]
      end
    EOF
  end
end
