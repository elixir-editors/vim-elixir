# encoding: utf-8
require 'spec_helper'

describe "Record syntax" do
  it "private record symbol" do
    assert_correct_syntax 'elixirAtom', ':user', <<-EOF
      defrecordp :user, name: "José", age: 25
    EOF
  end
end
