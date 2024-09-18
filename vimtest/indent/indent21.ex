defmodule Hello.World do
  def some_func do
    cond do
      {:abc} -> false
      _ -> true
    end
  end
end
