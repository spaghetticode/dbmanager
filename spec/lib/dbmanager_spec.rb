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
    it 'outputs the command that is executing' do
      output = STDStub.new
      Dbmanager.execute('echo', output)
      output.content.should include 'executing "echo"'
    end

    it 'executes a system command and returns the output' do
      Dbmanager.execute!('echo asd').chomp.should == 'asd'
    end

    it 'raises an error when not successful' do
      expect do
        Dbmanager.execute!('gibberish')
      end.to raise_error(Dbmanager::CommandError)
    end
  end

  describe '#execute' do
    it 'wraps a call to #execute!' do
      Dbmanager.should_receive(:execute!).and_return(true)
      Dbmanager.execute!('echo')
    end

    it 'raises no error when not successful' do
      expect do
        Dbmanager.execute('gibberish')
      end.to_not raise_error(Dbmanager::CommandError)
    end
  end
end
