require 'spec_helper'

module Dbmanager
  describe YmlParser do
    before do
     ::RAILS_ROOT = fixture_path unless defined? RAILS_ROOT
     YmlParser.config = nil
     YmlParser.stub! :db_config_file => File.join(fixture_path, 'database.yml')
   end

    describe '#config' do
      it 'should load a yml file with erb code inside' do
        YmlParser.config.should be_a(Hash)
      end

      it 'should cache the result' do
        YmlParser.config
        YAML.should_not_receive(:load)
        YmlParser.config
      end
    end

    describe '#reload_config' do
      it 'should reload the yml file' do
        YmlParser.config
        YAML.should_receive(:load)
        YmlParser.reload_config
      end
    end

    describe '#environments' do
      it 'should be an hash of open structs' do
        YmlParser.environments.should be_a(Hash)
        YmlParser.environments.values.should be_all do |item|
          item.is_a?(Environment)
        end
      end
    end
  end
end
