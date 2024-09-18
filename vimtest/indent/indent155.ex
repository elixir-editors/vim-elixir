def exec(command, progress_func \ fn(_, state) -> state end, key \ nil, output \ nil) do
  if key do
    with_cache(key, output, fn -> do_exec(command, progress_func) end)
  else
    do_exec(command, progress_func)
  end
end
