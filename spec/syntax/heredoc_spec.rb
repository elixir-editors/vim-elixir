require 'spec_helper'

describe "Heredoc syntax" do
  describe "binary" do
    it "with multiline content" do
      assert_correct_syntax 'elixirDocString', 'foo', <<-EOF
        @doc """
        foo
        """
      EOF
    end

    it "escapes quotes unless only preceded by whitespace" do
      assert_correct_syntax 'elixirDocString', %q(^\s*\zs"""), <<-EOF
        @doc """
        foo """
        """
      EOF
    end

    it "does not include content on initial line", focus: true do
      assert_correct_syntax 'elixirNumber', '0', <<-EOF
        String.at """, 0
        foo
        end
      EOF
    end

    it "with interpolation" do
      assert_correct_syntax 'elixirInterpolation', 'bar', <<-EOF
        @doc """
        foo \#{bar}
        """
      EOF
    end
  end

  describe "character list" do
    it "with multiline content" do
      assert_correct_syntax 'elixirDocString', 'foo', <<-EOF
        @doc """
        foo
        """
      EOF
    end

    it "escapes quotes unless only preceded by whitespace" do
      assert_correct_syntax 'elixirDocString', %q(^\s*\zs'''), <<-EOF
        @doc '''
        foo '''
        '''
      EOF
    end

    it "with interpolation" do
      assert_correct_syntax 'elixirInterpolation', 'bar', <<-EOF
        @doc '''
        foo \#{bar}
        '''
      EOF
    end
  end
end
