require 'spec_helper'

module Dbmanager
  describe Runner do
    let(:input) { STDStub.new }
    let(:output) { STDStub.new }

    module M
      class Connection
        def initialize(*args)
        end
      end
    end

    describe '#initialize' do
      let(:envs) { [mock] }

      subject { Runner.new(input, output) }

      before do
        YmlParser.stub!(:environments => envs)
        Runner.any_instance.stub(:set_adapter => M, :set_source => nil)
      end

      it 'sets expected attributes' do
        subject.input.should        == input
        subject.output.should       == output
        subject.environments.should == envs
        subject.adapter.should      == M
        subject.source.should be_a(Dbmanager::M::Connection)
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
          Dbmanager::Adapters.should_receive(:const_get).and_return(M)
          subject.set_adapter.should == M
        end
      end
    end

    describe '#set_source' do
      subject { Runner.new(input, output) }

      before { Runner.any_instance.stub(:set_adapter => M) }

      it 'outputs expected message' do
        Runner.any_instance.stub(:get_env => nil)
        subject.set_source
        output.content.should include('Please choose source db:')
      end
    end
  end
end
