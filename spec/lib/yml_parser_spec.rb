require 'spec_helper'

module Dbmanager
  describe YmlParser do
    before do
      stub_rails_root
      YmlParser.config = nil
    end

    describe '#config' do
      it 'should load a yml file with erb code inside' do
        YmlParser.config.should be_a(Hash)
      end

      it 'should cache the result' do
        YmlParser.stub :override_config => {}
        YmlParser.should_receive(:yml_load).once.and_return({:some => :conf})
        YmlParser.config
        YmlParser.config
      end
    end

    describe '#reload_config' do
      it 'should reload the yml file' do
        YmlParser.stub :override_config => {}
        YmlParser.should_receive(:yml_load).twice.and_return({:some => :conf})
        YmlParser.config
        YmlParser.reload_config
      end
    end

    describe '#environments' do
      it 'should be an hash of environments' do
        YmlParser.environments.should be_a(Hash)
        YmlParser.environments.values.should be_all do |item|
          item.is_a?(Environment)
        end
      end
    end

    context 'when there is a dbmanager_override file' do
      it 'should override regular settings' do
        YmlParser.config['beta']['host'].should == '345.345.345.345'
      end
    end
  end
end
