# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting anonymous functions' do
  context 'single body functions inside do block' do
    it 'is declared with fn syntax' do
      expect(<<~EOF).to be_elixir_indentation
      def do
        some_func = fn  x -> x end
      end
      EOF
    end

    it 'is declared with function syntax' do
      expect(<<~EOF).to be_elixir_indentation
      def do
        some_func = function do x -> x end
      end
      EOF
    end

    it 'spans in multiple lines' do
      expect(<<~EOF).to be_elixir_indentation
      def test do
        assert_raise Queue.Empty, fn ->
          Q.new |> Q.deq!
        end
      end
      EOF
    end

    it 'spans in multiple lines inside parentheses' do
      expect(<<~EOF).to be_elixir_indentation
      defmodule Test do
        def lol do
          Enum.map([1,2,3], fn x ->
            x * 3
          end)
        end
      end
      EOF
    end
  end

  context 'multiple body functions declaring' do
    it 'it with fn syntax' do
      expect(<<~EOF).to be_elixir_indentation
      fizzbuzz = fn
        0, 0, _ -> "FizzBuzz"
        0, _, _ -> "Fizz"
        _, 0, _ -> "Buzz"
        _, _, x -> x
      end
      EOF
    end

    it 'it with function syntax' do
      expect(<<~EOF).to be_elixir_indentation
      fizzbuzz = function do
        0, 0, _ -> "FizzBuzz"
        0, _, _ -> "Fizz"
        _, 0, _ -> "Buzz"
        _, _, x -> x
      end
      EOF
    end
  end

  it 'fn with pattern matching and :end' do
    expect(<<~EOF).to be_elixir_indentation
    fun1 = fn
      (:foo) ->
        :bar
        :end
    end
    EOF
  end

  it 'fn with pattern matching and :end' do
    expect(<<~EOF).to be_elixir_indentation
    fun2 = fn
      (:foo) ->
        :bar
        'end'
    end
    EOF
  end

  it 'fn with pattern matching and :end' do
    expect(<<~EOF).to be_elixir_indentation
    fun3 = fn
      (:foo) ->
        :bar
        :send
    end
    EOF
  end

  it 'fn with string with "end"' do
    expect(<<~EOF).to be_elixir_indentation
    fun2 = fn
      (:foo) ->
        :foo
        "string with end"
    end
    EOF
  end

  it 'fn with comment with "end"' do
    expect(<<~EOF).to be_elixir_indentation
    fun3 = fn
      (:foo) ->
        :foo
        :asd # end
    end
    EOF
  end

  it 'fn with comment with "end" and actual end' do
    expect(<<~EOF).to be_elixir_indentation
    fun3 = fn
      (:foo) ->
        :foo
    end # end
    EOF
  end
end
