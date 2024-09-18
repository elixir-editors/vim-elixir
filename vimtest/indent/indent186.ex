def test do
  [ h | t ] = "a,b,c,d"
              |> String.split(",")
              |> Enum.reverse

  { :ok, h }
end
