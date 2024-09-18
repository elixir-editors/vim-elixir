def render(assgins) do
  ~L"""
  <div>
    <%= for i <- iter do %>
      <div><%= i %></div>
    <% end %>
  </div>
  """
end
