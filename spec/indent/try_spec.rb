require 'spec_helper'

describe 'try indent' do
  i <<~EOF
  try do
  rescue
  end
  EOF

  i <<~EOF
  try do
  catch
  end
  EOF

  i <<~EOF
  try do
  after
  end
  EOF
end
