with {:ok, %File.Stat{size: size}} when size > 0 <- File.stat(first_frame_path) do
  File.rename(first_frame_path, output_path)
  {:ok, %Result{path: output_path}}
else
  error ->
    {:error, error}
end
