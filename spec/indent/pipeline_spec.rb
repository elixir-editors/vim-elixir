require 'spec_helper'

describe "Indenting" do
  it "using multiline pipeline" do
    assert_correct_indenting <<-EOF
    "a,b,c,d"
    |> String.split(",")
    |> Enum.reverse
    EOF
  end

  it "attribuition using multline pipeline operator" do
    assert_correct_indenting <<-EOF
    [ h | t ] = "a,b,c,d"
                |> String.split(",")
                |> Enum.reverse
    EOF
  end

  it "function with pipeline operator" do
    assert_correct_indenting <<-EOF
    def test do
      [ h | t ] = "a,b,c,d"
                  |> String.split(",")
                  |> Enum.reverse

      { :ok, h }
    end
    EOF
  end

  it "pipeline operator with block open" do
    assert_correct_indenting <<-EOF
    def test do
      "a,b,c,d"
      |> String.split(",")
      |> Enum.first
      |> case do
        "a" -> "A"
        _ -> "Z"
      end
    end
    EOF
  end

  it "using a record with pipeline" do
    assert_correct_indenting <<-EOF
    defrecord RECORD, field_a: nil, field_b: nil

    rec = RECORD.new
          |> IO.inspect
    EOF
  end
end
