# frozen_string_literal: true

require 'spec_helper'

describe 'config indenting' do
  i <<~EOF
  config :logger,
    level: (if level = System.get_env("LOG_LEVEL"), do: String.to_atom(level), else: :warn),
    protocol_version: :"tlsv1.2"
  EOF
end
