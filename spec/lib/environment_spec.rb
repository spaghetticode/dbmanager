require 'spec_helper'

module Dbmanager
  describe Environment do
    def opts
      {
        :name      => 'development',
        :adapter   => 'mysql',
        :database  => 'dev_db',
        :username  => 'user',
        :password  => 'secret',
        :port      => 3306,
        :host      => '123.123.123.123',
        :encoding  => 'utf8'
      }
    end

    describe 'a generic environment' do
      subject { Environment.new(:name => 'beta') }

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
  end
end
