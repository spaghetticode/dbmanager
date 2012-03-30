require 'spec_helper'
require 'fixtures/adapter_sample'

module Dbmanager
  describe Dumper do
    describe '#run' do
      let(:input) { STDStub.new }
      let(:output) { STDStub.new }

      subject { Dumper.new(input, output) }

      before do
        stub_rails_root
        input.stub!(:gets => mock.as_null_object)
        Dumper.any_instance.stub(
          :set_source       => nil,
          :adapter          => Adapters::SomeAdapter,
          :default_filename => 'default_filename'
        )
      end

      it 'dumps a db' do
        Adapters::SomeAdapter::Dumper.should_receive(:new).and_return(mock(:run => nil))
        subject.run
      end
    end
  end
end
