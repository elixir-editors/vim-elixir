defmodule Hi do
  def hi do
    fn hello ->
      :world
    end
  end
end
