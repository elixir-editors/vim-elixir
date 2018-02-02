# frozen_string_literal: true

require 'spec_helper'

describe 'Indenting case statements' do
  it 'case..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    case some_function do
      :ok ->
        :ok
      { :error, :message } ->
        { :error, :message }
    end
    EOF
  end

  it 'case..do..end' do
    expect(<<~EOF).to be_elixir_indentation
    case Connection.open(rabbitmq) do
      {:ok, conn} ->
        Woody.info "CONNECTION_SUCCESSFUL"
        {:ok, chan} = Channel.open(conn)
      {:error, error} ->
        Woody.info "CONNECTION_FAILED"
        :timer.sleep(10000)
    end
    EOF
  end

  it 'nested case statements' do
    expect(<<~EOF).to be_elixir_indentation
    defmodule M do
      defp _fetch(result, key, deep_key) do
        case _fetch(result, key) do
          {:ok, val} ->
            case _fetch(val, deep_key) do
              :error -> {:error, :deep}
              res -> res
            end

          :error -> {:error, :shallow}
        end
      end
    EOF
  end

  it 'type case..do..end' do
    expect(<<~EOF).to be_typed_with_right_indent
    case Connection.open(rabbitmq) do
      {:ok, conn} ->
        Woody.info "CONNECTION_SUCCESSFUL"
        {:ok, chan} = Channel.open(conn)
      {:error, error} ->
        Woody.info "CONNECTION_FAILED"
        :timer.sleep(10000)
    end
    EOF
  end

  it 'with long bodies' do
    expect(<<~'EOF').to be_elixir_indentation
    decoded_msg = case JSON.decode(msg) do
      {:error, _} ->
        a = "a"
        b = "dasdas"
        ">#{a}<>#{b}<"
      {:ok, decoded} -> decoded
    end
    EOF
  end

  i <<~EOF
  case Repo.insert(changeset) do
    {:ok, user} ->
      conn
      |> put_flash(:info, "%{user.name} created!")
      |> redirect(to: user_path(conn, :index))
    {:error, changeset} ->
      render(conn, "new.html", changeset: changeset)
  end
  EOF

  i <<~EOF
  case st do
    sym ->
      code = if true do
        :ok
      else
        :error
      end
      Logger.info(code)
      st
  end
  EOF

  i <<~EOF
  case world do
    "apple" ->
      IO.puts "its an apple"

      IO.puts "no really, its an apple"
    "orange" ->
      IO.puts "its not an apple"
      IO.puts "believe it or not"
  end
  EOF

  i <<~EOF
  case o do
    a ->
      e(fn -> f end)
  end
  EOF
end
