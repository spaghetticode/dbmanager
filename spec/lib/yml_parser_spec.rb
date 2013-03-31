require 'spec_helper'

module Dbmanager
  describe YmlParser do
    before do
      YmlParser.instance_eval { @config = nil }
    end

    describe '#config' do
      it 'loads a yml file with erb code inside' do
        YmlParser.config.should be_a(Hash)
      end

      it 'caches the result' do
        YmlParser.stub :override_config => {}
        YmlParser.should_receive(:yml_load).once.and_return({:some => :conf})
        YmlParser.config
        YmlParser.config
      end
    end

    describe '#reload_config' do
      it 'reloads the yml file' do
        YmlParser.stub :override_config => {}
        YmlParser.should_receive(:yml_load).twice.and_return({:some => :conf})
        YmlParser.config
        YmlParser.reload_config
      end
    end

    describe '#environments' do
      it 'is an hash of environments' do
        YmlParser.environments.should be_a(Hash)
        YmlParser.environments.values.should be_all do |item|
          item.is_a?(Environment)
        end
      end
    end

    context 'when there is a dbmanager_override file' do
      context 'when the file is empty' do
        it 'doesnt raise any error' do
          YAML.stub!(:load => nil)
          expect { YmlParser.config }.to_not raise_error
        end
      end

      context 'when the file is populated' do
        it 'overrides regular settings' do
          YmlParser.config['beta']['host'].should == '345.345.345.345'
        end

        it 'removes old unchanged settings' do
          YmlParser.config['beta']['username'].should == 'beta_user'
        end

        context 'when the environment has a ignoretables directive' do
          it 'should populate ignoretables with the expected array' do
            YmlParser.config['beta']['ignoretables'].should == ['some_view']
          end
        end
      end
    end
  end
end
