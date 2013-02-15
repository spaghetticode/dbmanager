require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Runnable do
    let(:envs)   { [mock] }
    let(:input)  { STDStub.new }
    let(:output) { STDStub.new }
    let(:klass)  { Class.new { include Runnable} }
    subject { klass.new(input, output) }

    before do
      YmlParser.stub!(:environments => envs)
      subject.stub(:get_environment => envs.first)
    end

    describe '#initialize' do
      it 'sets expected attributes' do
        subject.input.should        == input
        subject.output.should       == output
        subject.environments.should == envs
      end
    end

    describe '#get_env' do
      it 'outputs expected message' do
        subject.get_env('target')
        output.content.should include('Please choose target db:')
      end

      it 'returns the chosen environment' do
        subject.get_env('target').should == envs.first
      end
    end

    describe '#get_filename' do
      before { subject.stub(:input => input, :output => output) }

      it 'outputs expected message' do
        subject.get_filename('target', 'defaultname')
        output.content.should include('Please choose target file (defaults to defaultname):')
      end
    end
  end
end
