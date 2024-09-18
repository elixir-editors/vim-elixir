def render(assigns) do
  ~L"""
  <div>
    <%= render_component,
      @socket,
      Component %>
  </div>

  <%= render_component,
    @socket,
    Component %>
  <p>Multi-line single eex tag</p>
  """
end
