require 'spec_helper'

describe 'def indentation' do
  i <<~EOF
    def handle_call({:release_lock, key}, _from, state) do
      case get_lock(state, key) do
        nil ->
          {:reply, {:error, :already_unlocked}, state}

        _ ->
          new_state = delete_lock(state, key)
          {:reply, :ok, new_state}
      end
    end

    def
  EOF
end
