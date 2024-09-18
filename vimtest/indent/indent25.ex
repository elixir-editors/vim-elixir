defmodule Hello do
  def hello do
    case word do
      :one -> :two
      :high -> :low
    end
  end
end
