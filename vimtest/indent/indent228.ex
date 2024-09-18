def my_function do
  with :ok <- some_call,
       :ok <- another_call do

  end
end
