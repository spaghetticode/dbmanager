require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Importer do
    describe '#run' do
      let(:input) { STDStub.new }
      let(:output) { STDStub.new }

      subject { Importer.new(input, output) }

      before do
        stub_rails_root
        input.stub!(:gets => "1\n")
        Importer.any_instance.stub(:adapter => Adapters::SomeAdapter)
      end

      it 'imports a db' do
        Adapters::SomeAdapter::Importer.should_receive(:new).and_return(mock(:run => nil))
        subject.run
      end
    end
  end
end
