require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Runner do
    let(:envs)   { [mock] }
    let(:input)  { STDStub.new }
    let(:output) { STDStub.new }

    subject { Runner.new(input, output) }

    before do
      YmlParser.stub!(:environments => envs)
      subject.stub(:get_environment => envs.first)
    end

    describe '#initialize' do
      it 'sets expected attributes' do
        subject.input.should  == input
        subject.output.should == output
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
      it 'outputs expected message' do
        subject.get_filename('target', 'defaultname')
        output.content.should include('Please choose target file (defaults to defaultname):')
      end

      context 'when user inputs no filename' do
        before { subject.stub(:get_input => '') }

        it 'returns default filename when user did not provide one' do
          subject.get_filename('source', '/default.sql').should == '/default.sql'
        end
      end

      context 'when user inputs an absolute path' do
        before { subject.stub(:get_input => '/some/path.sql') }

        it 'returns the absolute path as a Pathname instance' do
          subject.get_filename('source', 'default').should == '/some/path.sql'
        end
      end

      context 'when user inputs a relative path' do
        before { subject.stub(:get_input => 'filename.sql') }

        it 'returns a pathname object' do
          subject.get_filename('source', 'default').should be_a(Pathname)
        end

        it 'appends the rails root to the path' do
          expected = Pathname.new("#{fixture_path}/rails/filename.sql")
          subject.get_filename('source', 'default').should == expected
        end
      end
    end
  end
end
