require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Connection do
        before { stub_rails_root }

        describe 'a mysql adapter instance' do
          subject { Connection.new Dbmanager::YmlParser.environments['test'] }

          it 'should delegate to environment object' do
            subject.host.should == subject.environment.host
          end

          describe '#params' do
            it 'should return expected string' do
              subject.params.should == '-uroot -pdevil -h345.345.345.345 -P3306 demo_test'
            end
          end

          describe '#protected?' do
            it 'should be true by default' do
              subject.should_not be_protected
            end

            context 'when name is production' do
              it ' should be true by default ' do
                subject.stub! :name => 'production'
                subject.should be_protected
              end

              context 'when protected is set to false' do
                it 'should be false' do
                  subject.stub! :name => 'production', :protected => false
                  subject.should_not be_protected
                end
              end
            end
          end

          describe '#flag' do
            context 'when requested flag has a value' do
              it 'should return expected string' do
                subject.flag(:password, :p).should == '-pdevil'
              end
            end

            context 'when requested flag has no value' do
              it 'should return a blank string' do
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

          it 'should have target and source attribute methods' do
            %w[source target].each { |m| subject.should respond_to(m) }
          end

          it 'should have a timestamped temporary file' do
            subject.temp_sql_file.should == '/tmp/120323123032'
          end

          describe '#import_command' do
            context 'when environment is not protected' do
              it 'should return expected command' do
                subject.import_command.should == 'mysql target-params < /tmp/120323123032'
              end
            end

            context 'when environment is protected' do
              it 'should raise expected error' do
                target.stub! :protected? => true
                expect { subject.import_command }.to raise_error(EnvironmentProtectedError)
              end
            end
          end

          describe '#run' do
            it 'should dump the db' do
              Dumper.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end

            it 'should try to import the db' do
              Dumper.stub! :new => mock.as_null_object
              Dbmanager.should_receive(:execute).with(subject.import_command)
              subject.run
            end
          end
        end
      end

      describe Dumper do
        subject { Dumper.new mock(:params => 'source-params'), '/tmp/dump_file.sql' }

        describe '#dump_command' do
          it 'should return expected command' do
            subject.dump_command.should == 'mysqldump source-params > /tmp/dump_file.sql'
          end
        end
      end
    end
  end
end
