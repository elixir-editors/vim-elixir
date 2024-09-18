def render(assigns) do
  ~L"""
  <%= render_component,
    @socket,
    Component do %>

    <p>Multi-line opening eex tag that takes a block</p>
  <% end %>
  """
end
