defmodule Hi do
  defp hi do
    try do
      raise "wtf"
    catch
      e ->
        IO.puts "one"

      _ ->
        IO.puts "one"
    end
  end
end
