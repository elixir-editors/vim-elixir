def alphabetical(query) do
  from c in query, order_by: c.name
end
