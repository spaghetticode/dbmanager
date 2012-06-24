require 'spec_helper'

module Dbmanager
  describe Environment do
    describe 'a generic environment' do
      subject { Environment.new :name => 'beta' }

      it { subject.should_not be_protected }

      context 'when the protected attribute is changed to true' do
        before { subject.protected = true }

        it { subject.should be_protected }
      end
    end

    describe 'the production environment' do
      subject { Environment.new(:name => 'production') }

      it { subject.should be_protected }

      context 'when the protected attribute is explicitly set to false' do
        before { subject.protected = false }

        it { subject.should_not be_protected }
      end
    end

    describe '#flag' do
      context 'when requested attribute is present' do
        before { subject.stub(:password => 'secret') }

        it 'returns a string containing the expected flag' do
          subject.flag(:password, :p).should == '-psecret'
        end
      end

      context 'when the requested attribute is not present' do
        it 'returns nil' do
          subject.flag(:foo, :p).should be_nil
        end
      end
    end
  end
end
