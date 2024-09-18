defmodule New do
  def do_query do
    from user in Users,
      select: user.name,
      join: signup in Signups, where: user.id == signup.user_id
  end
end
