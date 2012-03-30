class STDStub < StringIO
  def content
    rewind
    read
  end
end
