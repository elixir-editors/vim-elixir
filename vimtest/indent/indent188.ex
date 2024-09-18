def test do
  "a,b,c,d"
  |> String.split(",")
  |> Enum.first
  |> case do
    "a" -> "A"
    _ -> "Z"
  end
end
