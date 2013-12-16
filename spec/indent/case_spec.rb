require 'spec_helper'

describe "Indenting" do
  specify "case statements" do
    assert_correct_indenting <<-EOF
      case some_function do
        :ok ->
          :ok
        { :error, :message } ->
          { :error, :message }
      end
    EOF
  end
end
