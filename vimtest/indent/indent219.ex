with {:ok, msg} <- Msgpax.unpack(payload) do
  {:ok, rebuild(msg)}
else
  error -> error
end
