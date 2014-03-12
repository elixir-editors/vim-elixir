require 'tmpdir'
require 'vimrunner'

module Support
  def assert_correct_indenting(string)
    content = write_file(string)

    @vim.edit file
    # remove all indentation
    @vim.normal 'ggVG999<<'
    # force vim to indent the file
    @vim.normal 'gg=G'
    @vim.write

    read_file.should eq(content)
  end

  def assert_correct_syntax(syntax, cursor, string)
    write_file(string)

    @vim.edit file
    @vim.search cursor

    cursor_syntax_stack.should include(syntax)
  end

  def assert_incorrect_syntax(type, cursor, string)
    write_file(string)

    @vim.edit file
    @vim.search cursor

    cursor_syntax_stack.should_not include(type)
  end

  private

  def write_file(string)
    content = file_content(string)
    File.open file, 'w' do |f|
      f.write content
    end

    content
  end

  def file_content(string)
    whitespace = string.scan(/^\s*/).first
    string.split("\n").map { |line|
      line.gsub(/^#{whitespace}/, '')
    }.join("\n").strip
  end

  def cursor_syntax_stack
    @vim.echo <<-EOF
      map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    EOF
  end

  def read_file
    IO.read(file).strip
  end

  def file; 'test.exs'; end
end

RSpec.configure do |config|
  include Support

  config.before(:suite) do
    VIM = Vimrunner.start_gvim
    VIM.prepend_runtimepath(File.expand_path('../..', __FILE__))
    VIM.command('runtime ftdetect/elixir.vim')
  end

  config.after(:suite) do
    VIM.kill
  end

  config.around(:each) do |example|
    @vim = VIM

    # cd into a temporary directory for every example.
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        @vim.command("cd #{dir}")
        example.call
      end
    end
  end
end
