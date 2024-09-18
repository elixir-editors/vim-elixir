with {:ok, width} <- Map.fetch(opts, :width),
     double_width = width * 2,
     {:ok, height} <- Map.fetch(opts, :height)
do
  {:ok, double_width * height}
end
