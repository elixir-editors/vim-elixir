# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting Ecto queries' do
  it 'does not affect similar statements that are not queries' do
    expect(<<~EOF).to be_elixir_indentation
    def smth do
      from = 1
      to = 7
    end
    EOF

    expect(<<~EOF).to be_elixir_indentation
    fromin,
    EOF
  end

  it 'does not affect single lined queries' do
    expect(<<~EOF).to be_elixir_indentation
    query = from u in query, select: u.city
    EOF
  end

  it 'works correctly with inverted queries' do
    expect(<<~EOF).to be_elixir_indentation
    def do_query do
      where = [category: "fresh and new"]
      order_by = [desc: :published_at]
      select = [:id, :title, :body]
      from Post, where: ^where, order_by: ^order_by, select: ^select
    end
    EOF
  end

  i <<~EOF
  def alphabetical(query) do
    from c in query, order_by: c.name
  end
  EOF
end
