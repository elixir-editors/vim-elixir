# frozen_string_literal: true

require 'spec_helper'

describe 'integration indent' do
  i <<~EOF
  def select_next(some_var) do
    if eligible = some_fun(some_var) do
      eligible
      |> Enum.group_by(&(&1.group))            # Bin by group
      |> Map.values
      |> Enum.random                           # Select group at random
      |> Enum.sort(fn(thing1, thing2) ->         # Prioritize
        if thing1.priority == thing2.priority do
          thing1.media_id < thing2.media_id
        else
          thing1.priority > thing2.priority
        end
      end)
      |> hd                                    # Take the first
    end
  end
  EOF

  i <<~EOF
  defp do_assignment(some_var) do
    if thing = select_next_thing_for_some_var(some_var) do
      case ThingMaster.ThingDistributor.Sender.send_things_to_some_var([thing], some_var) do
        :ok ->
          case persist_thing(thing, some_var) do
            {:ok, thing} ->
              Logger.info("Assigned thing to thing", thing_id: thing.id, media_id: thing.media_id, some_var_url: some_var.url)
              thing
              |> get_info
              |> ThingMaster.ThingMonitor.start

              :ok
            _ ->
              Logger.error("Failed to persist assignment \#{thing.id}")
          end
        {:error, _} ->
          Logger.warn("Failed to send thing thing to \#{some_var.url}")
      end
    end
  end
  EOF
end
