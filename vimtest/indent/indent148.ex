def render(assigns) do
  ~L"""
  <%= live_component @socket,
    Component,
    id: "<%= @id %>",
    team: @team do
  %>

    <div>
      <div>
        <div>
          A deeply nested tree
          <div>
            with trailing whitespace

          </div>
        </div>
      </div>
    </div>

    <div id="id-ends-with-greater-than->"
      propWithEexTag="<%= @id %>"
      anotherProp="foo"
    />

    <%= for i <- iter do %>
      <div><%= i %></div>
    <% end %>

    <div
      opts={{
        opt1: "optA",
        opt2: "optB"
      }}
      id="hi"
      bye="hi" />

    <ul>
      <li :for={{ item <- @items }}>
        {{ item }}
      </li>
    </ul>

    <div id="hi">
      Hi <p>hi</p>
      I'm ok, ok?
      <div>
        hi there!
      </div>
      <div>
        <div>
          <p>hi</p>
          <hr />
        </div>
      </div>
    </div>

    <Some.Surface.Component />

    <Another
      prop="prop"
      prop2="prop2"
    >
      <div>content</div>
    </Another>

    <div foo />

    <div>hi</div>

    <div>
      <div>
        content
      </div>
      <div />
      <div>
        content in new div after a self-closing div
      </div>
    </div>

    <p
      id="<%= @id %>"
      class="multi-line opening single letter p tag"
    >
      <%= @solo.eex_tag %>
      <Nested
        prop="nested"
      >
        content
      </Nested>
    </p>

  <% end %>
  """
end
