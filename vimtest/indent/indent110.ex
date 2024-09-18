def handle_info(:tick, state = %{policy_iteration: []}) do
  state = put_in(state[:policy_iteration], state.policy)
  {:noreply, state}
end
