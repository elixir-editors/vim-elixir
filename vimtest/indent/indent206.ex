defmacro foo do
  quote do
    unquote(foo)
  end
end
