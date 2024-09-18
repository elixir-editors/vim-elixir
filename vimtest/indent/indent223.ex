with {:ok, width} <- Map.fetch(opts, :width),
     {:ok, height} <- Map.fetch(opts, :height),
     do:
       {:ok,
         width * height * height * height * height * height * height * height * height * height *
           height * height * height * height * height * height * height},
     else: (:error -> {:error, :wrong_data})
