if arg[:arg] do
  finish_time = Timex.Duration.now
  start_time = Mod.Mod.arg(@attr, fun(state))
  duration = Timex.Duration.diff(finish_time, start_time, :milliseconds)
  Mod.fun(:arg, arg, arg: arg, arg: arg, arg)
  e
