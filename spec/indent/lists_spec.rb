require 'spec_helper'

describe 'Indenting' do
  specify 'lists' do
    expect(<<-EOF).to be_elixir_indentation
      def example do
        [ :foo,
          :bar,
          :baz ]
      end
    EOF
  end

  specify 'nested list' do
    expect(<<-EOF).to be_elixir_indentation
      [
        [
          :foo
        ]
      ]
    EOF
  end

  specify 'keyword list' do
    expect(<<-EOF).to be_elixir_indentation
      def project do
        [ name: "mix",
          version: "0.1.0",
          deps: deps ]
      end
    EOF
  end

  specify 'keyword' do
    expect(<<-EOF).to be_elixir_indentation
      def config do
        [ name:
          "John" ]
      end
    EOF
  end

  specify 'list of tuples' do
    expect(<<-EOF).to be_elixir_indentation
    def test do
      [ { :cowboy, github: "extend/cowboy" },
        { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
        { :ecto, github: "elixir-lang/ecto" },
        { :pgsql, github: "semiocast/pgsql" } ]
    end
    EOF
  end

  specify 'list of lists' do
    expect(<<-EOF).to be_elixir_indentation
    def test do
      [ [:a, :b, :c],
        [:d, :e, :f] ]
    end
    EOF
  end

  specify 'complex list' do
    expect(<<-EOF).to be_elixir_indentation
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

  specify 'lists without whitespace' do
    expect(<<-EOF).to be_elixir_indentation
    def project do
      [{:bar, path: "deps/umbrella/apps/bar"},
       {:umbrella, path: "deps/umbrella"}]
    end
    EOF
  end

  specify 'lists with line break after square brackets' do
    expect(<<-EOF).to be_elixir_indentation
    def project do
      [
        { :bar, path: "deps/umbrella/apps/bar" },
        { :umbrella, path: "deps/umbrella" }
      ]
    end
    EOF
  end

  specify 'multiple lists with multiline elements' do
    expect(<<-EOF).to be_elixir_indentation
      def test do
        a = [
          %{
            foo: 1,
            bar: 2
          }
        ]

        b = %{
          [
            :foo,
            :bar
          ]
        }

        [
          a,
          b
        ]
      end
    EOF
  end

  it 'indent function body even when breaking the parameter list in many lines' do
    expect(<<-EOF).to be_elixir_indentation
    def create(conn, %{
      "grant_type" => "password",
      "username" => username,
      "password" => password
    }) do
      1
    end
    EOF
  end

  it 'parameters list in many lines' do
    expect(<<-EOF).to be_elixir_indentation
    def double(x) do
      add(x,
          y)
    end
    EOF
  end

  it 'long parameters list in many lines' do
    expect(<<-EOF).to be_elixir_indentation
    def double(x) do
      add(x,
          y,
          w,
          z)
    end
    EOF
  end
end
