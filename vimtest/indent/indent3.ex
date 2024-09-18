defmodule Test do
  def lol do
    Enum.map([1,2,3], fn x ->
      x * 3
    end)
  end
end
