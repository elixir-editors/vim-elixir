case Connection.open(rabbitmq) do
  {:ok, conn} ->
    Woody.info "CONNECTION_SUCCESSFUL"
    {:ok, chan} = Channel.open(conn)
  {:error, error} ->
    Woody.info "CONNECTION_FAILED"
    :timer.sleep(10000)
end
