case some_function do
  :ok ->
    :ok
  { :error, :message } ->
    { :error, :message }
end
