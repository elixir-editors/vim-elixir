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

    # Using this function with a `pattern` that is not in `content` is pointless.
    #
    # @vim.search() silently fails if a pattern is not found and the cursor
    # won't move. So, if the current cursor position happens to sport the
    # expected syntax group already, this can lead to false positive tests.
    #
    # We work around this by using Vim's search() function, which returns 0 if
    # there is no match.
    if @vim.echo("search(#{pattern.inspect})") == '0'
      return []
    end

    syngroups = @vim.echo <<~EOF
    map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    EOF

    # From: "['elixirRecordDeclaration', 'elixirAtom']"
    # To:   ["elixirRecordDeclaration", "elixirAtom"]
    syngroups.gsub!(/["'\[\]]/, '').split(', ')
  end

  private

  def with_file(content = nil)
    edit_file(content)

    yield if block_given?

    @vim.write
    @vim.command 'redraw'
    IO.read(@file)
  end

  def edit_file(content)
    File.write(@file, content) if content

    @vim.edit @file
  end
end

class Differ
  def self.diff(result, expected)
    instance.diff(result, expected)
  end

  def self.instance
    @instance ||= new
  end

  def initialize
    @differ = RSpec::Support::Differ.new(
      object_preparer: -> (object) do
        RSpec::Matchers::Composable.surface_descriptions_in(object)
      end,
      color: RSpec::Matchers.configuration.color?
    )
  end

  def diff(result, expected)
    @differ.diff_as_string(result, expected)
  end
end

module ExBuffer
  def self.new
    Buffer.new(VIM, :ex)
  end
end

module EexBuffer
  def self.new
    Buffer.new(VIM, :eex)
  end
end

RSpec::Matchers.define :be_typed_with_right_indent do |syntax|
  buffer = Buffer.new(VIM, syntax || :ex)

  match do |code|
    @typed = buffer.type(code)
    @typed == code
  end

  failure_message do |code|
      <<~EOM
      Expected

      #{@typed}
      to be indented as

      #{code}
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
      reindented = buffer.reindent(code)
      reindented == code
    end

    failure_message do |code|
      <<~EOM
      Expected

      #{buffer.reindent(code)}
      to be indented as

      #{code}
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
      to include syntax '#{syntax}'
      for pattern: /#{pattern}/
      in:
        #{code}
      EOF
    end

    failure_message_when_negated do |code|
      <<~EOF
      expected #{buffer.syntax(code, pattern)}
      *NOT* to include syntax '#{syntax}'
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
    VIM.add_plugin(File.expand_path('..', __dir__))
    VIM.command('filetype off')
    VIM.command('filetype plugin indent on')
    VIM.command('autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o') # disable automatic comment continuation
    VIM.normal(":set ignorecase<CR>") # make sure we test ignorecase
    VIM
  end
end

RSpec.configure do |config|
  config.order = :random

  # Run a single spec by adding the `focus: true` option
  config.filter_run_including focus: true
  config.run_all_when_everything_filtered = true
end

RSpec::Core::ExampleGroup.instance_eval do
  def i(str)
    gen_tests(:it, str)
  end

  def ip(str)
    gen_tests(:pending, str)
  end

  private

  def gen_tests(method, str)
    send method, "\n#{str}" do
      reload = -> do
        VIM.add_plugin(File.expand_path('..', __dir__), 'ftdetect/elixir.vim')
        received = ExBuffer.new.reindent(str)
        puts received
        str == received
      end
      actual = ExBuffer.new.reindent(str)
      expect(actual).to eq(str)
    end

    send method, "typed: \n#{str}" do
      expect(str).to be_typed_with_right_indent
    end
  end
end
