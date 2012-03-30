require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Connection do
        before { stub_rails_root }

        describe 'a mysql adapter instance' do
          subject { Connection.new Dbmanager::YmlParser.environments['test'] }

          it 'delegates to environment object' do
            subject.host.should == subject.environment.host
          end

          describe '#params' do
            it 'returns expected string' do
              subject.params.should == '-uroot -pdevil -h345.345.345.345 -P3306 demo_test'
            end
          end

          describe '#protected?' do
            it 'is false by default' do
              subject.should_not be_protected
            end

            context 'when name matches production string' do
              it 'is true by default ' do
                subject.stub! :name => 'production-merge'
                subject.should be_protected
              end

              context 'when protected is set to false' do
                it 'is false' do
                  subject.stub! :name => 'production', :protected => false
                  subject.should_not be_protected
                end
              end
            end
          end

          describe '#flag' do
            context 'when requested flag has a value' do
              it 'returns expected string' do
                subject.flag(:password, :p).should == '-pdevil'
              end
            end

            context 'when requested flag has no value' do
              it 'returns a blank string' do
                subject.stub!(:password => nil)
                subject.flag(:password, :p).should == ''
              end
            end
          end
        end
      end

      describe Importer do
        describe 'an importer instance' do
          before  { Time.stub! :now => Time.parse('2012/03/23 12:30:32') }
          let(:target) { mock :params => 'target-params', :protected? => false, :name => 'beta'  }
          let(:source) { mock :params => 'source-params', :protected? => false, :name => 'development' }
          subject { Importer.new source, target  }

          it 'has target and source attribute methods' do
            %w[source target].each { |m| subject.should respond_to(m) }
          end

          it 'has a timestamped temporary file' do
            subject.temp_file.should == '/tmp/120323123032'
          end

          describe '#import_command' do
            context 'when environment is not protected' do
              it 'returns expected command' do
                subject.import_command.should == 'mysql target-params < /tmp/120323123032'
              end
            end

            context 'when environment is protected' do
              it 'raises EnvironmentProtectedError' do
                target.stub! :protected? => true
                expect { subject.import_command }.to raise_error(EnvironmentProtectedError)
              end
            end
          end

          describe '#remove_temp_file' do
            it 'tries to remove the temporary file' do
              Dbmanager.should_receive(:execute).with("rm #{subject.temp_file}")
              subject.remove_temp_file
            end
          end

          describe '#run' do
            it 'dumps the db' do
              Dumper.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end

            it 'imports the db' do
              Dumper.stub! :new => mock.as_null_object
              subject.stub!(:remove_temp_file => true)
              Dbmanager.should_receive(:execute).with(subject.import_command)
              subject.run
            end
          end
        end
      end

      describe Dumper do
        subject { Dumper.new mock(:params => 'source-params'), '/tmp/dump_file.sql' }

        describe '#dump_command' do
          it 'returns expected command' do
            subject.dump_command.should == 'mysqldump source-params > /tmp/dump_file.sql'
          end
        end
      end
    end
  end
end
