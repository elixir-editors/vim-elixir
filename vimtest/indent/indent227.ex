def create_user(params) do
  profile = UserProfile.registration_changeset(%UserProfile{}, params)

  user_cs =
    %User{}
    |> User.registration_changeset(params)
    |> put_assoc(:user_profile, profile)

  with {:ok, user} <- Repo.insert(user_cs, returning: false) do
    Log.info(%Log{user: user.id, message: "user created"})
    send_welcome(user)
    {:ok, user}
  end
end
