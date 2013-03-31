require 'spec_helper'

module Dbmanager
  describe Importer do
    subject { described_class.new(STDStub.new, STDStub.new) }

    before { subject.stub :get_env => mock(:database => 'beta') }

    it { should respond_to :source }
    it { should respond_to :target }

    describe '#run' do
      context 'when target is protected' do
        before { subject.stub :target => mock(:protected? => true) }

        it 'raises EnvironmentProtectedError' do
          expect { subject.run }.to raise_error(EnvironmentProtectedError)
        end
      end

      context 'when target is not protected' do
        before { subject.stub :target => mock(:protected? => false) }

        it 'successfully complete import' do
          subject.stub(:execute_import => nil)
          subject.run
          message = 'Database Import completed.'
          subject.output.content.should include(message)
        end
      end
    end

    describe '#tmp_file' do
      it 'includes expected path' do
        Time.stub :now => Time.parse('1974/09/20 14:12:33')
        subject.tmp_file.should =~ Regexp.new('dbmanager/spec/fixtures/rails/tmp/740920141233')
      end
    end

    context 'when source and target have same adapter' do
      before do
        subject.stub(
          :source => mock(:adapter => 'mysql2'),
          :target => mock(:adapter => 'mysql2', :protected? => false)
        )
      end

      it 'uses the expected adapter' do
        subject.adapter.should == Dbmanager::Adapters::Mysql2
      end

      it 'delegates importing process to the adapter importer' do
        adapter_importer = Dbmanager::Adapters::Mysql2::Importer
        adapter_importer.should_receive(:new).and_return mock.as_null_object
        subject.run
      end
    end

    context 'when source and target adapters differ' do
      before do
        subject.stub(
          :source => mock(:adapter => 'sqlite3'),
          :target => mock(:adapter => 'mysql2')
        )
      end

      it 'adapter raises MixedAdapterError' do
        expect {subject.adapter}.to raise_error(MixedAdapterError)
      end
    end
  end
end
