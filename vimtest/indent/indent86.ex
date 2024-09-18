defmodule Hi do
  defp hi do
    receive do
      {:hello, world} ->
        :ok

      _ ->
        :err
    end
  end
end
