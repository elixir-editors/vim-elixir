# frozen_string_literal: true

require 'rspec/expectations'
require 'tmpdir'
require 'vimrunner'
require 'vimrunner/rspec'

class Buffer
  def initialize(vim, type)
    @file = ".fixture.#{type}"
    @vim = vim
  end

  def reindent(content)
    with_file content do
      # remove all indentation
      @vim.normal 'ggVG999<<'
      # force vim to indent the file
      @vim.normal 'gg=G'
      # save the changes
      sleep 0.1 if ENV['CI']
    end
  end

  def type(content)
    with_file do
      @vim.normal 'gg'

      content.each_line.each_with_index do |line, index|
        if index.zero?
          @vim.type("i#{line.strip}")
        else
          @vim.normal 'o'
          @vim.type(line.strip)
        end
      end
    end
  end

  def syntax(content, pattern)
    with_file content
    # move cursor the pattern
    @vim.search pattern
    # get a list of the syntax element
    @vim.echo <<~EOF
    map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    EOF
  end

  private

  def with_file(content = nil)
    edit_file(content)

    yield if block_given?

    @vim.write
    IO.read(@file)
  end

  def edit_file(content)
    File.open(@file, 'w') { |f| f.write content } if content

    @vim.edit @file
  end
end

class Differ
  def self.diff
    RSpec::Support::Differ.new(
      object_preparer: -> (object) do
        RSpec::Matchers::Composable.surface_descriptions_in(object)
      end,
      color: RSpec::Matchers.configuration.color?
    )
  end
end

RSpec::Matchers.define :be_typed_with_right_indent do |syntax|
  buffer = Buffer.new(VIM, syntax || :ex)

  match do |code|
    buffer.type(code) == code
  end

  failure_message do |code|
    <<~EOM
    #{Differ.diff.diff_as_string(code, buffer.type(code))}
    EOM
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
      <<~EOM
      #{Differ.diff.diff_as_string(code, buffer.reindent(code))}
      EOM
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
      buffer.syntax(code, pattern).include? syntax.to_s
    end

    failure_message do |code|
      <<~EOF
      expected #{buffer.syntax(code, pattern)}
      to include syntax #{syntax}
      for pattern: /#{pattern}/
      in:
        #{code}
      EOF
    end

    failure_message_when_negated do |code|
      <<~EOF
      expected #{buffer.syntax(code, pattern)}
      *NOT* to include syntax #{syntax}
      for pattern: /#{pattern}/
      in:
        #{code}
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

RSpec.configure do |config|
  config.order = :random
end
