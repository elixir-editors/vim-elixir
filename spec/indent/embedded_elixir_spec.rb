require 'spec_helper'

describe 'Indenting' do
  describe 'Embedded Elixir' do
    it 'anonymous function' do
      expect(<<-EOF).to be_eelixir_indentation
      # An Example
      <%= form_for @changeset, user_path(@conn, :create), fn f -> %>
        It is obviously true
      <% end %>
      ---
      EOF
    end

    it 'if-clauses' do
      expect(<<-EOF).to be_eelixir_indentation
      # An Example
      <%= if true do %>
        It is obviously true
      <% end %>
      ---
      EOF
    end

    it 'if-else-clauses' do
      expect(<<-EOF).to be_eelixir_indentation
      # An Example
      <%= if true do %>
        It is obviously true
      <% else %>
        This will never appear
      <% end %>
      ---
      EOF
    end
  end
end
