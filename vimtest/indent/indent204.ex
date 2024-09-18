def hello do
  do_something
  |> Pipe.to_me
  {:ok}
end
