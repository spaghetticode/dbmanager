require File.expand_path('../../lib/dbmanager', __FILE__)

RSpec.configure do |config|
  config.color_enabled = true
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end
