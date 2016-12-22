# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting Ecto queries' do
  it 'works correctly' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule New do
      def do_query do
        from user in Users,
          select: user.name,
          join: signup in Signups, where: user.id == signup.user_id
      end
    end
    EOF
  end

  it 'works with different macros' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule New do
      def do_query do
        from user in Users,
          select: user.name,
          join: signup in Signups,
          where: user.id == signup.user_id,
          having: avg(user.posts) > 10,
          group_by: user.age
      end
    end
    EOF
  end
end
