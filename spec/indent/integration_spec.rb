# frozen_string_literal: true

require 'spec_helper'

describe 'Integration among all indentation rules' do
  pending do
    expect(<<~EOF).to be_elixir_indentation
    defmodule Module do
      @person1 { name: "name",
        age: 18,
        enabled?: true }
      @person2 { name: "other name",
        age: 21,
        enabled?: false }

      def function_with_not_nested_lists do
        foo == %{
        }

        assert json_response == %{
          "id" => "identifier"
        }
      end

      def test_another_feature do
        assert json_response(conn, 200) == %{
          "results" => [
            %{
              "id" => result.id,
            }
          ]
        }
      end

      def double(x) do
        resutl = add(x,
                     z)
        div(result, 2)
      end

      def create(conn, %{
        "grant_type" => "password",
        "username" => username,
        "password" => password
      }) do
        1
      end

      def project do
        [
          { :bar, path: "deps/umbrella/apps/bar" },
          { :umbrella, path: "deps/umbrella" }
        ]
      end

      def project do
        [{:bar, path: "deps/umbrella/apps/bar"},
         {:umbrella, path: "deps/umbrella"}]
      end
    end
    EOF
  end
end
