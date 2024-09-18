defmodule Hi do
  def hi do
    fn hello ->
      case hello do
        :one ->
          case word do
            :one ->
              :two

            :high ->
              :low
          end
          :two

        :high ->
          :low
      end
    end
  end
end
