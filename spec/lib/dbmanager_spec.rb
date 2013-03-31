require 'spec_helper'

describe Dbmanager do
  describe '#rails_root', :skip_stub_rails_root => true do
    it 'wraps Rails.root' do
      Rails = mock unless defined? Rails
      Rails.should_receive :root
      Dbmanager.rails_root
    end
  end

  describe '#execute' do
    it 'executes a system command' do
      Dbmanager.should_receive(:system)
      Dbmanager.execute('echo')
    end

    it 'outputs the command that is executing' do
      output = STDStub.new
      Dbmanager.execute('echo', output)
      output.content.should include 'executing "echo"'
    end
  end

  describe '#execute!' do
    it 'wraps a call to #execute' do
      Dbmanager.should_receive(:execute).and_return(true)
      Dbmanager.execute!('echo')
    end

    it 'raises an error when not successful' do
      Dbmanager.stub!(:system => false)
      expect do
        Dbmanager.execute!('echo')
      end.to raise_error(Dbmanager::CommandError)
    end
  end
end
