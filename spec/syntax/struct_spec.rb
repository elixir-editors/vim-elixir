require 'spec_helper'

describe "Struct syntax" do
  it "without defaults" do
    assert_correct_syntax 'elixirAtom', ':name', <<-EOF
      defstruct [:name, :age]
    EOF
  end

  it "with defaults" do
    assert_correct_syntax 'elixirAtom', 'name:', <<-EOF
      defstruct name: "john", age: 27
    EOF
  end
end
