require 'spec_helper'

describe "Indenting" do
  specify "'do' indenting" do
    <<-EOF
      do
        something
      end
    EOF
    .should be_elixir_indentation
  end

  it "does not consider :end as end" do
    <<-EOF
      defmodule Test do
        def lol do
          IO.inspect :end
        end
      end
    EOF
    .should be_elixir_indentation
  end

  it "does not consider do: as the start of a block" do
    <<-EOF
      def f do
        if true, do: 42
      end
    EOF
    .should be_elixir_indentation
  end

  it "do not mislead atom ':do'" do
    <<-EOF
      def f do
        x = :do
      end
    EOF
    .should be_elixir_indentation
  end
end
