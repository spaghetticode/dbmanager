require 'spec_helper'

describe Dbmanager do
  describe '#rails_root' do
    it 'should wrap Rails.root' do
      Rails = mock unless defined? Rails
      Rails.should_receive :root
      Dbmanager.rails_root
    end
  end

  describe '#execute' do
    it 'execute a system command' do
      Dbmanager.should_receive(:system)
      Dbmanager.execute('echo')
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
