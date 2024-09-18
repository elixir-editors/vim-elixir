defmodule Hi do
  defp hi do
    fn
      :ok ->
        IO.puts :ok
      _ ->
        IO.puts :err
    end
  end
end
