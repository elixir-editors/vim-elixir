with {:ok, foo} <- thing(1),
     {:ok, bar} <- thing(2) do
  foo + bar
end
