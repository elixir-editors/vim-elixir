hello =
  "str"
  |> Pipe.do_stuff
  |> Pipe.do_stuff

  |> Pipe.do_stuff
  |> Pipe.do_stuff(fn ->
    more stuff
  end)

  |> Pipe.do_stuff
