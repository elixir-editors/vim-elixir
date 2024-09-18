def init(_) do
  children = [
    worker(QueueSet, [[name: @queue_set]]),
    worker(Producer, [[name: @producer]]),
    worker(ConsumerSupervisor, [[{@producer, max_demand: @max_executors}]])
  ]

  supervise(children, strategy: :one_for_one)
end
