defmodule Hi do
  defp hi do
    try do
      raise "boom"
    rescue
      e in errs ->
        IO.puts "one"

      _ ->
        IO.puts "one"
    end
  end
end
