receive do
  {{:lock_ready, ^key}, ^pid} ->
after
  # NOTE: @jbodah 2017-03-28: we should do some math to adjust the timeout
  timeout ->
    {:error, :timed_out_waiting_for_lock}
end
