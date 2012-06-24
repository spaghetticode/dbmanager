require 'spec_helper'

module Dbmanager
  describe Importable do
    subject do
      Object.new.tap {|o| o.extend Importable}
    end

    before do
      subject.stub :output => STDStub.new, :input => STDStub.new, :get_env => nil
    end

    it 'has target attribute reader' do
      subject.instance_eval { @target = 'something'}
      subject.target.should == 'something'
    end

    context 'when source and target have same adapter' do
      before do
        subject.stub(
          :source => mock(:adapter => 'mysql2'),
          :target => mock(:adapter => 'mysql2')
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

    describe '#run' do
      it 'outputs expected messages' do
        subject.stub(:execute_import => nil)
        subject.run
        message = 'Database Import completed.'
        subject.output.content.should include(message)
      end
    end
  end
end
