def do_query do
  where = [category: "fresh and new"]
  order_by = [desc: :published_at]
  select = [:id, :title, :body]
  from Post, where: ^where, order_by: ^order_by, select: ^select
end
