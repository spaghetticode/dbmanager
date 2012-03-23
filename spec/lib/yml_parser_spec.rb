require 'spec_helper'

module Dbmanager
  describe YmlParser do
    before { stub_database_yml }

    describe '#config' do
      it 'should load a yml file with erb code inside' do
        YmlParser.config.should be_a(Hash)
      end

      it 'should cache the result' do
        YAML.should_receive(:load).once.and_return('something')
        YmlParser.config
        YmlParser.config
      end
    end

    describe '#reload_config' do
      it 'should reload the yml file' do
        YAML.should_receive(:load).twice.and_return('something')
        YmlParser.config
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
