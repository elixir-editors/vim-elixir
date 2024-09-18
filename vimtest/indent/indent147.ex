def render(assigns) do
  ~H"""
  <Component
    foo={{
      foo: [
        'one',
        'two',
        'three'
      ],
      bar: %{
        "foo" => "bar"
      }
    }}
  />
  """
end
