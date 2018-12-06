require 'spec_helper'

describe 'nested modules' do
  i <<~EOF
  case System.argv do
    ["--test"] ->
      ExUnit.start()

      defmodule FrequencyTest do
        use ExUnit.Case

        import Frequency

        test "final_frequency" do
          assert repeated_frequency([

          ]) == 2
        end
      end
  end
  EOF
end
