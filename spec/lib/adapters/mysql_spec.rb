require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Dumper do
        let :source do
          mock(
            :username     => 'root',
            :ignoretables => ['a_view', 'another_view'],
            :database     => 'database',
            :password     => 'secret',
            :port         => 42,
            :host         => '0.0.0.0'
          ).as_null_object # so it behaves precisely like an OpenStruct instance
        end

        subject { Dumper.new(source, '/tmp/dump_file.sql') }

        describe '#flag' do
          context 'when the source has the requested flag' do
            it 'returns a string containing the expected flag' do
              subject.flag(:password, :p).should == '-psecret'
            end
          end

          context 'when the source has not the requested flag' do
            it 'returns an empty string' do
              subject.flag(:foo, :p).should == ''
            end
          end
        end

        describe '#params' do
          it 'returns expected string' do
            subject.params.should == '-uroot -psecret -h0.0.0.0 -P42 database'
          end
        end

        describe '#ignoretables' do
          context 'when there are tables to be ignored' do
            it 'returns a string containing ignore-table flags' do
              string = '--ignore-table=database.a_view --ignore-table=database.another_view'
              subject.ignoretables.should == string
            end
          end

          context 'when there are no tables to be ignored' do
            it 'returns nil' do
              source.stub!(:ignoretables => nil)
              subject.ignoretables.should be_nil
            end
          end
        end

        describe '#dump_command' do
          it 'returns expected command' do
            command = [
              'mysqldump --ignore-table=database.a_view',
              '--ignore-table=database.another_view -uroot',
              '-psecret -h0.0.0.0 -P42 database > /tmp/dump_file.sql'
            ].join(' ')
            subject.dump_command.should == command
          end
        end
      end

      describe Importer do
        describe 'an importer instance' do
          before { Time.stub! :now => Time.parse('2012/03/23 12:30:32') }
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
              Dbmanager.stub!(:execute! => nil)
              Dumper.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end

            it 'imports the db' do
              Dumper.stub! :new => mock.as_null_object
              subject.stub!(:remove_temp_file => true)
              Dbmanager.should_receive(:execute!).with(subject.import_command)
              subject.run
            end
          end
        end
      end
    end
  end
end
