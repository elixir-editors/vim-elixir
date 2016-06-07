require 'spec_helper'

describe "Defmodule syntax" do
  it "defines `defmodule` keyword as elixirModuleDefine" do
    <<-EOF
      defmodule HelloPhoenix.HelloController do
    EOF
    .should include_elixir_syntax('elixirModuleDefine', 'defmodule')
  end

  it "defines module name as elixirModuleDeclaration" do
    <<-EOF
      defmodule HelloPhoenix.HelloController do
    EOF
    .should include_elixir_syntax('elixirModuleDeclaration', 'HelloPhoenix.HelloController')
  end

  it "does not define module name as elixirAlias" do
    <<-EOF
      defmodule HelloPhoenix.HelloController do
    EOF
    .should_not include_elixir_syntax('elixirAlias', 'HelloPhoenix.HelloController')
  end

  it "defines `do` keyword as elixirBlock" do
    <<-EOF
      defmodule HelloPhoenix.HelloController do
    EOF
    .should include_elixir_syntax('elixirBlock', 'do')
  end

end

