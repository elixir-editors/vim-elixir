def render(assigns) do
  ~L"""
  <%= live_component @socket,
    Component,
    id: "<%= @id %>",
    user: @user do
  %>

    <main>
      <header>
        <h1>Some Header</h1>
      </header>
      <section>
        <h1>Some Section</h1>
        <p>
          I'm some text
        </p>
      </section>
    </main>

  <% end %>
  """
end
