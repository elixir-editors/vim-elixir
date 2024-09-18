defmodule Test do
  def test do
    one =
      user
      |> build_assoc(:videos)
      |> Video.changeset()

    other =
      user2
      |> build_assoc(:videos)
      |> Video.changeset()
  end
end
