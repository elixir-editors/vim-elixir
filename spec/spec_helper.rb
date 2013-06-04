require 'tmpdir'
require 'vimrunner'

module Support
  def assert_correct_indenting(string)
    whitespace = string.scan(/^\s*/).first
    string = string.split("\n").map { |line| line.gsub /^#{whitespace}/, '' }.join("\n").strip

    File.open 'test.exs', 'w' do |f|
      f.write string
    end

    @vim.edit 'test.exs'
    @vim.normal 'gg=G'
    @vim.write

    IO.read('test.exs').strip.should eq string
  end
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
