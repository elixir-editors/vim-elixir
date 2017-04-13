# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting lists' do
  it 'lists' do
    expect(<<~EOF).to be_elixir_indentation
    def example do
      [ :foo,
        :bar,
        :baz ]
    end
    EOF
  end

  it 'nested list' do
    expect(<<~EOF).to be_elixir_indentation
    [
      [
        :foo
      ]
    ]
    EOF
  end

  it 'keyword list' do
    expect(<<~EOF).to be_elixir_indentation
    def project do
      [ name: "mix",
        version: "0.1.0",
        deps: deps ]
    end
    EOF
  end

  it 'keyword' do
    expect(<<~EOF).to be_elixir_indentation
    def config do
      [ name:
        "John" ]
    end
    EOF
  end

  it 'list of tuples' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      [ { :cowboy, github: "extend/cowboy" },
        { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" },
        { :ecto, github: "elixir-lang/ecto" },
        { :pgsql, github: "semiocast/pgsql" } ]
    end
    EOF
  end

  it 'list of lists' do
    expect(<<~EOF).to be_elixir_indentation
    def test do
      [ [:a, :b, :c],
        [:d, :e, :f] ]
    end
    EOF
  end

  it 'complex list' do
    expect(<<~EOF).to be_elixir_indentation
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

  it 'lists without whitespace' do
    expect(<<~EOF).to be_elixir_indentation
    def project do
      [{:bar, path: "deps/umbrella/apps/bar"},
       {:umbrella, path: "deps/umbrella"}]
    end
    EOF
  end

  it 'lists with line break after square brackets' do
    expect(<<~EOF).to be_elixir_indentation
    def project do
      [
        { :bar, path: "deps/umbrella/apps/bar" },
        { :umbrella, path: "deps/umbrella" }
      ]
    end
    EOF
  end

  it 'multiple lists with multiline elements' do
    expect(<<~EOF).to be_elixir_indentation
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
    expect(<<~EOF).to be_elixir_indentation
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
    expect(<<~EOF).to be_elixir_indentation
    def double(x) do
      add(x,
          y)
    end
    EOF
  end

  it 'long parameters list in many lines' do
    expect(<<~EOF).to be_elixir_indentation
    def double(x) do
      add(x,
          y,
          w,
          z)
    end
    EOF
  end

  describe 'restore last indentation after multiline lists' do
    it 'correct indentation after long parameter list' do
      expect(<<~EOF).to be_elixir_indentation
      def double(x) do
        resutl = add(x,
                     z)
        div(result, 2)
      end
      EOF
    end

    it 'correct indentation after long map list' do
      expect(<<~EOF).to be_elixir_indentation
      defmodule Module do
        @person1 { name: "name",
          age: 18,
          enabled?: true }
        @person2 { name: "other name",
          age: 21,
          enabled?: false }
      end
      EOF
    end
  end

  describe 'mix of opened symbols' do
    it 'indents every opened symbol' do
      expect(<<~EOF).to be_elixir_indentation
      def test_another_feature do
        assert json_response(conn, 200) == %{
          "results" => [
            %{
              "id" => result.id,
            }
          ]
        }
      end
      EOF
    end

    it 'reset indentation on not nested lists' do
      expect(<<~EOF).to be_elixir_indentation
      defmodule Mod do
        def test do
          foo == %{
          }

          assert json_response == %{
            "id" => "identifier"
          }
        end
      end
      EOF
    end
  end

  it 'reset the indent level afer long parameter list' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Mod do
      def fun do
        json_logger = Keyword.merge(Application.get_env(:logger, :json_logger, []), options)
        Application.put_env(:logger, :json_logger, json_logger)
        level  = Keyword.get(json_logger, :level)

        %{level: level, output: :console}
      end
    end
    EOF
  end

  it 'reset the indent level after complex list of parameters' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Mod do
      def fun do
        Enum.each(s.routing_keys, fn k -> Queue.bind(chan, s.queue, s.exchange, routing_key: k) end)
        Basic.consume(chan, s.queue, nil, no_ack: true)
      end
    end
    EOF
  end

  i <<~EOF
  def init(_) do
    children = [
      worker(QueueSet, [[name: @queue_set]]),
      worker(Producer, [[name: @producer]]),
      worker(ConsumerSupervisor, [[{@producer, max_demand: @max_executors}]])
    ]

    supervise(children, strategy: :one_for_one)
  end
  EOF
end
