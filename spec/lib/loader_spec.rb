require 'spec_helper'

module Dbmanager
  describe Loader do

    subject { described_class.new(STDStub.new, STDStub.new) }

    describe '#run' do
      before do
        subject.stub(
          :loader       => mock.as_null_object,
          :get_env      => mock(:database => 'beta'),
          :get_filename => 'filename'
        )
      end

      it 'sends expected output' do
        subject.run
        subject.output.content.should include('Database successfully loaded from filename.')
      end

      it 'delegates the actual loading to the loader' do
        loader = subject.send(:loader)
        loader.should_receive(:run)
        subject.run
      end
    end
  end
end
