def test_another_feature do
  assert json_response(conn, 200) == %{
    "results" => [
      %{
        "id" => result.id,
      }
    ]
  }
end
