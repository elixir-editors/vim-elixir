defmodule Hello do
  def name, do: IO.puts "bobmarley"
  # expect next line starting here

  def name(param) do
    param
  end
end
