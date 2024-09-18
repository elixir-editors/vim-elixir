def test do
  a = [
    %{
      foo: 1,
      bar: 2
    }
  ]

  b = %{
    [
      :foo,
      :bar
    ]
  }

  [
    a,
    b
  ]
end
