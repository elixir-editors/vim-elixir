case Repo.insert(changeset) do
  {:ok, user} ->
    conn
    |> put_flash(:info, "%{user.name} created!")
    |> redirect(to: user_path(conn, :index))
  {:error, changeset} ->
    render(conn, "new.html", changeset: changeset)
end
