# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting *after* comments' do
  it 'commented "do" should not cause next line to indent' do
    expect(<<~EOF).to be_elixir_indentation
    # do
    IO.puts :test
    EOF
  end

  it 'aligns comments with pipes' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Foo do
      def run do
        list =
          File.read!("/path/to/file")
          |> String.split()
          # now start a new line
          # used to start here
          # but now starts here
      end
    end
    EOF
  end

  it 'aligns comments after guard clause func' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Foo do
      def run(task) when task in [:t1, :t2] do
      end

      # now starts a new line
      # use to start here
      # but now starts here
    end
    EOF
  end

  it 'comments in after block' do
    expect(<<~EOF).to be_elixir_indentation
    receive do
      {{:lock_ready, ^key}, ^pid} ->
    after
      # NOTE: @jbodah 2017-03-28: we should do some math to adjust the timeout
      timeout ->
        {:error, :timed_out_waiting_for_lock}
    end
    EOF
  end
end

