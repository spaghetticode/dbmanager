class OutputStub < StringIO
  def content
    rewind
    read
  end
end
