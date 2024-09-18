def test do
  [ app: :first,
    version: "0.0.1",
    dynamos: [First.Dynamo],
    compilers: [:elixir, :dynamo, :ecto, :app],
    env: [prod: [compile_path: "ebin"]],
    compile_path: "tmp/first/ebin",
    deps: deps ]
end
