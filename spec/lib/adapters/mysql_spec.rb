require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Connection do
        before { stub_database_yml }

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
          subject { Importer.new mock(:params => 'source-params'), mock(:params => 'target-params') }

          it 'should have target and source attribute methods' do
            %w[source target].each { |m| subject.should respond_to(m) }
          end

          it 'should have a timestamped temporary file' do
            subject.temp_sql_file.should == '/tmp/120323123032'
          end

          describe '#dump_command' do
            it 'should return expected command' do
              subject.dump_command.should == 'mysqldump source-params > /tmp/120323123032'
            end
          end

          describe '#import_command' do
            it 'should return expected command' do
              subject.import_command.should == 'mysql target-params < /tmp/120323123032'
            end
          end

          describe '#run' do
            it 'should execute 2 system commands' do
              subject.should_receive(:system).twice
              subject.run
            end
          end
        end
      end
    end
  end
end
