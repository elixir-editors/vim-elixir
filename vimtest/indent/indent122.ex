defmodule Foo do
  def run do
    list =
      File.read!("/path/to/file")
      |> String.split()
    # now start a new line
    # used to start here
    # but now starts here
  end
end
