require File.expand_path('../../lib/dbmanager', __FILE__)

  RSpec.configure do |config|
  config.color_enabled = true
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

::RAILS_ROOT = fixture_path unless defined? RAILS_ROOT

def stub_database_yml
  Dbmanager::YmlParser.config = nil
  Dbmanager::YmlParser.stub! :db_config_file => File.join(fixture_path, 'database.yml')
end
