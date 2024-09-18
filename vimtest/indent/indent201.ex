upcased_names = names
                |> Enum.map(fn name ->
                  String.upcase(name)
                end)

IO.inspect names
