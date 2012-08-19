require File.expand_path('../../lib/dbmanager', __FILE__)
require 'support/std_stub'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def stub_rails_root
  Dbmanager.stub! :rails_root => "#{fixture_path}/rails"
end
