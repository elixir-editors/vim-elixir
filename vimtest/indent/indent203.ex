upcased_names = names
                |> Enum.map(fn name ->
                  String.upcase(name)
                end)

                |> do_stuff
