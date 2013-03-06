require 'spec_helper'

module Dbmanager
  describe Dumper do
    subject { described_class.new }

    before do
      subject.stub :output => STDStub.new, :input => STDStub.new
    end

    describe '#run' do
      before do
        subject.stub(
          :get_env          => 'test',
          :get_filename     => 'filename',
          :default_filename => 'defaultname',
          :dumper           => mock.as_null_object
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
