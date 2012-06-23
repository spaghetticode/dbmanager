require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Runner do
    let(:envs)   { [mock] }
    let(:input)  { STDStub.new }
    let(:output) { STDStub.new }

    before do
      YmlParser.stub!(:environments => envs)
      Runner.any_instance.stub(:get_environment => envs.first)
    end

    describe '#initialize' do
      subject { Runner.new(input, output) }

      it 'sets expected attributes' do
        subject.input.should        == input
        subject.output.should       == output
        subject.environments.should == envs
        subject.source.should       == envs.first
      end
    end

    describe '#get_env' do
      subject { Runner.new(input, output) }

      it 'outputs default message' do
        subject.get_env
        output.content.should include('Please choose source db:')
      end

      it 'outputs expected message' do
        subject.get_env('target')
        output.content.should include('Please choose target db:')
      end

      it 'returns the chosen environment' do
        subject.get_env.should == envs.first
      end
    end
  end
end
