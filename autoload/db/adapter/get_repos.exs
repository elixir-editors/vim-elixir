defmodule LoadRepos do
  defp load_apps do
    :code.get_path()
    |> Enum.flat_map(fn app_dir ->
      Path.join(app_dir, "*.app") |> Path.wildcard()
    end)
    |> Enum.map(fn app_file ->
      app_file |> Path.basename() |> Path.rootname(".app") |> String.to_atom()
    end)
    |> Enum.map(&Application.load/1)
  end

  defp configs do
    for {app, _, _} <- Application.loaded_applications(),
        repos = Application.get_env(app, :ecto_repos),
        is_list(repos) and repos != [],
        repo <- repos,
        do: {repo, Map.new(Application.get_env(app, repo))}
  end

  defp config_to_url(_, %{url: url}), do: url

  defp config_to_url(repo, %{
         hostname: hostname,
         username: username,
         password: password,
         database: database
       }) do
    %URI{
      scheme: adapter_to_string(repo.__adapter__),
      userinfo: "#{username}:#{password}",
      host: hostname,
      path: Path.join("/", database)
    }
    |> URI.to_string()
  end

  defp adapter_to_string(Ecto.Adapters.Postgres), do: "postgres"
  defp adapter_to_string(Ecto.Adapters.MySQL), do: "mysql"
  defp adapter_to_string(mod), do: raise("Unknown adapter #{inspect(mod)}")

  def main do
    load_apps()

    configs()
    |> Enum.map(fn {repo, config} ->
      [inspect(repo), ?\s, config_to_url(repo, config)]
    end)
    |> Enum.intersperse(?\n)
    |> IO.puts()
  end
end

LoadRepos.main()
