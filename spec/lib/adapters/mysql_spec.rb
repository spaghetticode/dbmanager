require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Dumper do
        let :source do
          Environment.new(
            :username     => 'root',
            :ignoretables => ['a_view', 'another_view'],
            :database     => 'database',
            :password     => 'secret',
            :port         => 42,
            :host         => '0.0.0.0'
          )
        end

        subject { Dumper.new(source, '/tmp/dump_file.sql') }

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
          let(:target)   { Environment.new :protected => false, :name => 'beta', :username => 'beta_user' }
          let(:source)   { Environment.new :protected => false, :name => 'development', :username => 'root' }
          let(:tmp_file) { '/some/arbitrary/path' }
          subject        { Importer.new source, target, tmp_file }

          it 'has target and source attribute methods' do
            %w[source target tmp_file].each { |m| subject.should respond_to m }
          end

          describe '#import_command' do
            it 'returns expected command' do
              subject.import_command.should == 'mysql -ubeta_user < /some/arbitrary/path'
            end
          end

          describe '#create_db_if_missing_command' do
            it 'returns expected command' do
              subject.create_db_if_missing_command.should == 'bundle exec rake db:create RAILS_ENV=beta'
            end
          end

          describe '#remove_tmp_file' do
            it 'tries to remove the temporary file' do
              Dbmanager.should_receive(:execute).with("rm #{subject.tmp_file}")
              subject.remove_tmp_file
            end
          end

          describe '#bundle' do
            it 'returns "bundle exec" when bundler is present' do
              Dbmanager.should_receive(:execute).and_return true
              subject.bundle.should == 'bundle exec'
            end

            it 'returns empty string when bundler is missing' do
              Dbmanager.should_receive(:execute).and_return false
              subject.bundle.should be_nil
            end
          end

          describe '#run' do
            it 'dumps the db' do
              Dbmanager.stub!(:execute! => nil)
              Dumper.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end

            it 'creates the db if missing and then imports the db' do
              Dumper.stub! :new => mock.as_null_object
              subject.stub!(:remove_tmp_file => true)
              Dbmanager.should_receive(:execute!).with(subject.import_command)
              Dbmanager.should_receive(:execute!).with(subject.create_db_if_missing_command)
              subject.run
            end
          end
        end
      end
    end
  end
end
