def resend_confirmation(username) when is_binary(username) do
  with user = %User{confirmed_at: nil} <- get_by(username: username) do
    {:ok, user} =
      user
      |> DB.add_confirm_token
      |> update_user()
    Log.info(%Log{user: user.id, message: "send new confirmation"})
    send_welcome(user)
    {:ok, user}
  else
    nil ->
      {:error, "not found"}
    %User{email: email} ->
      Email.already_confirmed(email)
      {:error, "already confirmed"}
  end
end
