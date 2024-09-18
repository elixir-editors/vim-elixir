def obtain_lock(pid, key, timeout \ 60_000) do
  case GenServer.call(pid, {:obtain_lock, key}) do
    :will_notify ->
      receive do
      after
        timeout ->
      end
    res -> res
  end
end
