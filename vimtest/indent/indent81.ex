defmodule Hi do
  defp hi do
    %Struct{
      :one,
      :two,
      fn ->
        :three
      end,
      :four
    }
  end
end
