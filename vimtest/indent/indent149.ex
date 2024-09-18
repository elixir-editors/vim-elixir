test "test" do
  Mod.fun(fn ->
    map = %Mod.Map{
      id: "abc123",
      state: "processing",
      submod: %Mod.Submod{
        options: %{}
      }
    }
