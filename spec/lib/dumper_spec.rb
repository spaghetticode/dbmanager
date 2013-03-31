require 'spec_helper'

module Dbmanager
  describe Dumper do
    subject { described_class.new(STDStub.new, STDStub.new) }

    describe '#run' do
      before do
        subject.stub(
          :dumper       => mock.as_null_object,
          :get_env      => mock(:database => 'beta'),
          :get_filename => 'filename'
        )
      end

      it 'sends expected output when successful' do
        subject.run
        subject.output.content.should include('Database successfully dumped in filename file.')
      end

      it 'delegates the actual dumping to the dumper' do
        dumper = subject.send(:dumper)
        dumper.should_receive(:run)
        subject.run
      end
    end
  end
end
