defmodule Mod do
  def fun do
    Enum.each(s.routing_keys, fn k -> Queue.bind(chan, s.queue, s.exchange, routing_key: k) end)
    Basic.consume(chan, s.queue, nil, no_ack: true)
  end
end
