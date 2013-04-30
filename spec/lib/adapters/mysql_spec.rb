require 'spec_helper'

module Dbmanager
  module Adapters
    module Mysql
      describe Dumper do
        before { Dbmanager.stub :output => STDStub.new }

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
            [
              'mysqldump --ignore-table=database.a_view',
              '--ignore-table=database.another_view',
              '-uroot -psecret -h0.0.0.0 -P42 database',
              '> \'/tmp/dump_file.sql\''
            ].each do |command_part|
              subject.dump_command.should include command_part
            end
          end

          context 'when mysqldump version is >= than 5.6' do
            before do
              subject.stub(:get_mysqldump_version => 'mysqldump  Ver 10.13 Distrib 5.6.0, for osx10.8 (i386)')
            end

            it {subject.mysqldump_version.should == 5.6 }

            it 'adds a flag that sets off gtid-purged' do
              subject.dump_command.should include '--set-gtid-purged=OFF'
            end
          end

          context 'when mysqldump version is < than 5.6' do
            before do
              subject.stub(:get_mysqldump_version => 'mysqldump  Ver 10.13 Distrib 5.5.28, for osx10.8 (i386)')
            end

            it {subject.mysqldump_version.should == 5.5 }

            it 'adds a flag that sets off gtid-purged' do
              subject.dump_command.should_not include '--set-gtid-purged=OFF'
            end

          end
        end
      end

      describe Loader do
        before { Dbmanager.stub :output => STDStub.new }

        describe 'an importer instance' do
          before { Time.stub! :now => Time.parse('2012/03/23 12:30:32') }
          let(:source)   { Environment.new :protected => false, :name => 'development', :username => 'root' }
          let(:target)   { Environment.new :protected => false, :name => 'beta', :username => 'beta_user' }
          let(:tmp_file) { '/some/arbitrary/path' }
          subject        { Loader.new target, tmp_file }

          it 'has target and tmp_file attribute methods' do
            %w[target tmp_file].each { |m| subject.should respond_to m }
          end

          describe '#load_command' do
            it 'returns expected command' do
              subject.load_command.should == 'mysql -ubeta_user < \'/some/arbitrary/path\''
            end
          end

          describe '#create_db_if_missing_command' do
            it 'returns expected command' do
              subject.create_db_if_missing_command.should == 'bundle exec rake db:create RAILS_ENV=beta'
            end
          end

          describe '#bundle' do
            it 'returns "bundle exec" when bundler is present' do
              Dbmanager.should_receive(:execute).and_return true
              subject.bundle.should == 'bundle exec'
            end

            it 'returns nil when bundler is missing' do
              Dbmanager.should_receive(:execute).and_return false
              subject.bundle.should be_nil
            end
          end

          describe '#run' do
            it 'creates the db if missing and then imports the db' do
              subject.stub!(:remove_tmp_file => true)
              Dbmanager.should_receive(:execute!).with(subject.create_db_if_missing_command)
              Dbmanager.should_receive(:execute!).with(subject.load_command)
              subject.run
            end
          end
        end
      end

      describe Importer do
        def environment(opts={})
          opts = {:protected => false}.merge(opts)
          Environment.new opts
        end

        before { Dbmanager.stub :output => STDStub.new }

        describe 'an importer instance' do
          before  { Time.stub! :now => Time.parse('2012/03/23 12:30:32') }

          subject { Importer.new source, target, tmp_file }

          let(:source)   { environment(:name => 'development', :username => 'root') }
          let(:target)   { environment(:name => 'beta', :username => 'beta_user') }
          let(:tmp_file) { '/some/arbitrary/path' }

          it 'has target, source and tmp_file attribute methods' do
            %w[source target tmp_file].each { |m| subject.should respond_to m }
          end

          describe '#remove_tmp_file' do
            it 'tries to remove the temporary file' do
              Dbmanager.should_receive(:execute).with('rm \'/some/arbitrary/path\'')
              subject.remove_tmp_file
            end
          end

          describe '#run' do
            it 'create ad Dumper that will dump the db' do
              Dbmanager.stub!(:execute! => nil)
              Dumper.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end

            it 'create ad Loader that will dump the db' do
              Dbmanager.stub!(:execute! => nil)
              Loader.should_receive(:new).and_return(mock.as_null_object)
              subject.run
            end
          end
        end
      end
    end
  end
end
