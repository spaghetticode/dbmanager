require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Runner do
    let(:input) { STDStub.new }
    let(:output) { STDStub.new }

    describe '#initialize' do
      let(:envs) { [mock] }

      subject { Runner.new(input, output) }

      before do
        YmlParser.stub!(:environments => envs)
        Runner.any_instance.stub(:set_adapter => Adapters::SomeAdapter, :set_source => nil)
      end

      it 'sets expected attributes' do
        subject.input.should        == input
        subject.output.should       == output
        subject.environments.should == envs
        subject.adapter.should      == Adapters::SomeAdapter
        subject.source.should be_a(Adapters::SomeAdapter::Connection)
      end
    end

    describe '#set_adapter' do
      subject { Runner.new(input, output) }

      before { Runner.any_instance.stub(:set_source => nil) }

      context 'when different adapters are mixed' do
        it 'raises an error' do
          envs = {:beta => mock(:adapter => 'Mysql'), :development => mock(:adapter => 'Sqlite3')}
          subject.stub!(:environments => envs)
          expect { subject.set_adapter }.to raise_error(AdapterError)
        end
      end

      context 'when there is only one kind of adapter' do
        it 'returns an adapter class' do
          envs = {:beta => mock(:adapter => 'Mysql'), :development => mock(:adapter => 'Mysql')}
          subject.instance_variable_set '@environments', envs
          Dbmanager::Adapters.should_receive(:const_get).and_return(Adapters::SomeAdapter)
          subject.set_adapter.should == Adapters::SomeAdapter
        end
      end
    end

    describe '#set_source' do
      subject { Runner.new(input, output) }

      before { Runner.any_instance.stub(:set_adapter => Adapters::SomeAdapter) }

      it 'outputs expected message' do
        Runner.any_instance.stub(:get_env => nil)
        subject.set_source
        output.content.should include('Please choose source db:')
      end
    end
  end
end
