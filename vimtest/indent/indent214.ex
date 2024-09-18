test "it proceses the command" do
  out = "testfile"
  try do
    cmd = "thing #{@test_file} #{out}"
    {:ok, 0, _} = Thing.exec(cmd)
  after
    File.rm!(out)
  end
end
