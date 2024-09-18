defmodule M do
  defp _fetch(result, key, deep_key) do
    case _fetch(result, key) do
      {:ok, val} ->
        case _fetch(val, deep_key) do
          :error -> {:error, :deep}
          res -> res
        end

      :error -> {:error, :shallow}
    end
  end
