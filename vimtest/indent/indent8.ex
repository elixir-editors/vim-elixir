defp handle_chunk(:err, line, state) do
  update_in(state[:stderr], fn
    hello -> :ok
    world -> :ok
  end)

  Map.update(state, :stderr, [line], &(&1 ++ [line]))
end
