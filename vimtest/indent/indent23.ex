defmodule Hello.World do
  def some_func do
    cond do
      {:abc} ->
        say_hello
        say_goodbye

      _ ->
        say_hello
        say_goodbye
    end
  end
end
