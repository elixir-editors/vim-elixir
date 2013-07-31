require 'spec_helper'

describe "Sigil syntax" do
  describe "upper case" do
    it "binary" do
      assert_correct_syntax 'elixirDelimiter', 'B', '%B(binary)'
      assert_correct_syntax 'elixirSigil', 'foo', '%B(binary)'
    end

    it "character list" do
      assert_correct_syntax 'elixirDelimiter', 'C', '%C(charlist)'
      assert_correct_syntax 'elixirSigil', 'charlist', '%C(charlist)'
    end

    it "regular expression" do
      assert_correct_syntax 'elixirDelimiter', 'R', '%R(regex)'
      assert_correct_syntax 'elixirSigil', 'regex', '%R(regex)'
    end

    it "list of words" do
      assert_correct_syntax 'elixirDelimiter', 'W', '%W(list of words)'
      assert_correct_syntax 'elixirSigil', 'list', '%W(list of words)'
    end

    it "delimited with parans" do
      assert_correct_syntax 'elixirDelimiter', '(', '%B(foo bar)'
      assert_correct_syntax 'elixirDelimiter', ')', '%B(foo bar)'
    end

    it "delimited with braces" do
      assert_correct_syntax 'elixirDelimiter', '{', '%B{foo bar}'
      assert_correct_syntax 'elixirDelimiter', '}', '%B{foo bar}'
    end

    it "delimited with brackets" do
      assert_correct_syntax 'elixirDelimiter', '[', '%B[foo bar]'
      assert_correct_syntax 'elixirDelimiter', ']', '%B[foo bar]'
    end

    it "without escapes" do
      assert_incorrect_syntax 'elixirRegexEscape', '\\', '%B(foo \n bar)'
    end

    it "without interpolation" do
      assert_incorrect_syntax 'elixirInterpolation', 'bar', '%B(foo #{bar})'
    end

    it "without escaped parans" do
      assert_incorrect_syntax 'elixirRegexEscapePunctuation', '( ', '%B(\( )'
    end
  end

  describe "lower case" do
    it "binary" do
      assert_correct_syntax 'elixirDelimiter', 'b', '%b(binary)'
      assert_correct_syntax 'elixirSigil', 'foo', '%b(binary)'
    end

    it "character list" do
      assert_correct_syntax 'elixirDelimiter', 'c', '%c(charlist)'
      assert_correct_syntax 'elixirSigil', 'charlist', '%c(charlist)'
    end

    it "regular expression" do
      assert_correct_syntax 'elixirDelimiter', 'r', '%r(regex)'
      assert_correct_syntax 'elixirSigil', 'regex', '%r(regex)'
    end

    it "list of words" do
      assert_correct_syntax 'elixirDelimiter', 'w', '%w(list of words)'
      assert_correct_syntax 'elixirSigil', 'list', '%w(list of words)'
    end

    it "with escapes" do
      assert_correct_syntax 'elixirRegexEscape', '\\', '%b(foo \n bar)'
    end

    it "with interpolation" do
      assert_correct_syntax 'elixirInterpolation', 'bar', '%b(foo #{bar})'
    end

    it "with escaped parans" do
      assert_correct_syntax 'elixirRegexEscapePunctuation', '( ', '%b(\( )'
    end
  end
end
