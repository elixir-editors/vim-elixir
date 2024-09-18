defmodule Hi do
  defp hi do
    receive do
      {:hello, world} ->
        :ok
    after
      1000 ->
        IO.puts "one"

      2000 ->
        IO.puts "one"
    end
  end
end
