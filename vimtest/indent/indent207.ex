defmacro foo do
  if 1 = 1 do
    quote do
      unquote(foo)
    end
  end
end
