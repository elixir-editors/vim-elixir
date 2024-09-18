def test do
  assert_raise Queue.Empty, fn ->
    Q.new |> Q.deq!
  end
end
