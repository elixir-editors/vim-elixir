def render(assigns) do
  ~H"""
  <div class="theres a-/ in the class names from tailwind">
    <div class="some more classes">
      This is immediately nested
      <div>
        <input type="number" value="2" />
        There's a self-closing tag
      </div>
    </div>
  </div>
  """
end
