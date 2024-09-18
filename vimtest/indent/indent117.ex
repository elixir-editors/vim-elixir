case st do
  sym ->
    code = if true do
      :ok
    else
      :error
    end
    Logger.info(code)
    st
end
