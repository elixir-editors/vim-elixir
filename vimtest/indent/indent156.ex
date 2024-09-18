def handle_call({:get_in_line_for_lock, key}, from, state) do
  queue = state[:queues][key] || :queue.new
  queue = queue.in(from, queue)
  hello
end
