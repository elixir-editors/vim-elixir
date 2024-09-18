with {:ok, width} <- Map.fetch(opts, :width),
     {:ok, height} <- Map.fetch(opts, :height)
do
  {:ok, width * height}
else
  :error ->
    {:error, :wrong_data}
end
