decoded_msg = case JSON.decode(msg) do
  {:error, _} ->
    a = "a"
    b = "dasdas"
    ">#{a}<>#{b}<"
  {:ok, decoded} -> decoded
end
