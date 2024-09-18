test "test" do
  Mod.fun(fn ->
    map = %Mod.Map{
      id: "abc123",
      fun: fn ->
        IO.inspect :hello
        IO.inspect %{
          this_is: :a_map
        }
      end,
      submod: %Mod.Submod{
        options: %{}
      }
    }
