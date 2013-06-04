require 'spec_helper'

describe "Indenting" do
  context "one liner functions inside do block declaring" do
    it "with fn syntax" do
      assert_correct_indenting <<-EOF
        def do
          some_func = fn  x -> x end
        end
      EOF
    end

    it "with function syntax" do
      assert_correct_indenting <<-EOF
        def do
          some_func = function do x -> x end
        end
      EOF
    end
  end

  context "multiple body functions declaring" do
    it "it with fn syntax" do
      assert_correct_indenting <<-EOF
        fizzbuzz = fn
          0, 0, _ -> "FizzBuzz"
          0, _, _ -> "Fizz"
          _, 0, _ -> "Buzz"
          _, _, x -> x
        end
      EOF
    end

    it "it with function syntax" do
      assert_correct_indenting <<-EOF
        fizzbuzz = function do
          0, 0, _ -> "FizzBuzz"
          0, _, _ -> "Fizz"
          _, 0, _ -> "Buzz"
          _, _, x -> x
        end
      EOF
    end
  end
end
