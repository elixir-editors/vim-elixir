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

  specify "list of tuples" do
    assert_correct_indenting <<-EOF
    def test do
      [ { :cowboy, github: "extend/cowboy" },
        { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
        { :ecto, github: "elixir-lang/ecto" },
        { :pgsql, github: "semiocast/pgsql" } ]
    end
    EOF
  end

  specify "list of lists" do
    assert_correct_indenting <<-EOF
    def test do
      [ [:a, :b, :c],
        [:d, :e, :f] ]
    end
    EOF
  end

  specify "complex list" do
    assert_correct_indenting <<-EOF
    def test do
      [ app: :first,
        version: "0.0.1",
        dynamos: [First.Dynamo],
        compilers: [:elixir, :dynamo, :ecto, :app],
        env: [prod: [compile_path: "ebin"]],
        compile_path: "tmp/first/ebin",
        deps: deps ]
    end
    EOF
  end

  specify "lists with break line after square brackets" do
    assert_correct_indenting <<-EOF
    def project do
      deps: [
        { :bar, path: "deps/umbrella/apps/bar" },
        { :umbrella, path: "deps/umbrella" }
      ]
    end
    EOF
  end
end
