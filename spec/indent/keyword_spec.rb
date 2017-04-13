require 'spec_helper'

describe 'Keywords' do
  i <<~EOF
  def handle_call({:get_in_line_for_lock, key}, from, state) do
    queue = state[:queues][key] || :queue.new
    queue = queue.in(from, queue)
    hello
  end
  EOF

  # Has cond in milliseconds
  i <<~EOF
    if arg[:arg] do
      finish_time = Timex.Duration.now
      start_time = Mod.Mod.arg(@attr, fun(state))
      duration = Timex.Duration.diff(finish_time, start_time, :milliseconds)
      Mod.fun(:arg, arg, arg: arg, arg: arg, arg)
      e
  EOF
end
