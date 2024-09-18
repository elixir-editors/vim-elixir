def test do
  my_post = Post
            |> where([p], p.id == 10)
            |> where([p], u.user_id == 1)
            |> select([p], p)
end
