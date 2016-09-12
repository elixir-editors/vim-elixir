# frozen_string_literal: true

require 'rspec/expectations'
require 'tmpdir'
require 'vimrunner'
require 'vimrunner/rspec'

class Buffer
  def initialize(vim, type)
    @file = ".fixture.#{type}"
    @vim  = vim
  end

  def reindent(code)
    open code do
      # remove all indentation
      @vim.normal 'ggVG999<<'
      # force vim to indent the file
      @vim.normal 'gg=G'
      sleep 0.1 if ENV['CI']
    end
  end

  def syntax(code, pattern)
    read code
    # move cursor the pattern
    @vim.search pattern
    # get a list of the syntax element
    @vim.echo <<~EOF
    map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    EOF
  end

  private

  def open(code)
    read code
    # run vim commands
    yield if block_given?
    @vim.write
    IO.read(@file)
  end

  def read(code)
    File.open(@file, 'w') { |f| f.write code }
    @vim.edit @file
  end
end

{
  be_elixir_indentation:  :ex,
  be_eelixir_indentation: :eex
}.each do |matcher, type|
  RSpec::Matchers.define matcher do
    buffer = Buffer.new(VIM, type)

    match do |code|
      buffer.reindent(code) == code
    end

    failure_message do |code|
      <<~EOF
      got:
      #{buffer.reindent(code)}
      after elixir indentation
      EOF
    end
  end
end

{
  include_elixir_syntax:  :ex,
  include_eelixir_syntax: :eex
}.each do |matcher, type|
  RSpec::Matchers.define matcher do |syntax, pattern|
    buffer = Buffer.new(VIM, type)

    match do |code|
      buffer.syntax(code, pattern).include? syntax
    end

    failure_message do |code|
      <<~EOF
      expected #{buffer.syntax(code, pattern)}
      to include syntax #{syntax}
      for pattern: /#{pattern}/
      in:
        #{actual}
      EOF
    end

    failure_message_when_negated do |code|
      <<~EOF
      expected #{buffer.syntax(code, pattern)} not to include syntax #{syntax}
      for pattern: /#{pattern}/
      in:
        #{actual}
      EOF
    end
  end
end

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  config.start_vim do
    VIM = Vimrunner.start_gvim
    VIM.add_plugin(File.expand_path('..', __dir__), 'ftdetect/elixir.vim')
    VIM
  end
end
