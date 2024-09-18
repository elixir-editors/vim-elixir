defp handle_chunk(:err, line, state) do
  update_in(state[:stderr], fn
    true -> true
    false -> false
  end)

  Map.update(state, :stderr, [line], &(&1 ++ [line]))
end
