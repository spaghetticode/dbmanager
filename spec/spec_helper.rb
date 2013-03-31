$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'dbmanager'

RSpec.configure do |config|
  config.order = :random
  config.color_enabled = true
  config.formatter = 'documentation'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.before(:each) do
    stub_rails_root unless example.metadata[:skip_stub_rails_root]
  end
end


class STDStub < StringIO
  def content
    rewind
    read
  end
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def stub_rails_root
  Dbmanager.stub :rails_root => Pathname.new("#{fixture_path}/rails")
end
