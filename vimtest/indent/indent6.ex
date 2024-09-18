{:ok, 0} = Mod.exec!(cmd, fn progress ->
  if event_handler do
    event_handler.({:progress_updated, progress})
  end
end
)
