defmodule Hi do
  defp hi do
    {
      :one,
      :two,
      fn ->
        :three
      end,
      :four
    }
  end
end
