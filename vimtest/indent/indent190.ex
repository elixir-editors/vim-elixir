defmodule MyMod do
  def export_info(users) do
    {:ok, infos} = users
                   |> Enum.map(fn (u) -> do_something(u) end)
                   |> Enum.map(fn (u) ->
                     do_even_more(u)
                   end)
                   |> finall_thing

    infos
  end
end
