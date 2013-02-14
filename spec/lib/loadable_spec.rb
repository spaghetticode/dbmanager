require 'spec_helper'

module Dbmanager
  describe Loadable do
    subject { described_class.new }
    before { subject.stub :output => STDStub.new, :input => STDStub.new }

    describe '#run' do
      before do
        subject.stub(
          :get_env          => 'test',
          :get_filename     => 'filename',
          :default_filename => 'defaultname',
          :loader           => mock.as_null_object,
        )
      end

      it 'sends expected output' do
        subject.run
        subject.output.content.should include('Database successfully loaded from filename.')
      end

      it 'delegates the actual dumping to the dumper' do
        subject.send(:dumper).should_receive(:run)
        subject.run
      end
    end
  end
end
