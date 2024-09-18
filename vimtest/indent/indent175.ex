defmodule Mod do
  def fun do
    json_logger = Keyword.merge(Application.get_env(:logger, :json_logger, []), options)
    Application.put_env(:logger, :json_logger, json_logger)
    level  = Keyword.get(json_logger, :level)

    %{level: level, output: :console}
  end
end
