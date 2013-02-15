require 'spec_helper'

module Dbmanager
  describe Dumpable do
    subject { Dumpable.new }

    before do
      stub_rails_root
      subject.stub :output => STDStub.new, :input => STDStub.new
    end

    describe '#run' do
      before do
        subject.stub(
          :get_env          => 'test',
          :get_filename     => 'filename',
          :default_filename => 'defaultname',
          :dumper           => mock.as_null_object,
        )
      end

      it 'sends expected output' do
        subject.run
        subject.output.content.should include('Database successfully dumped in filename file.')
      end

      it 'delegates the actual dumping to the dumper' do
        subject.send(:dumper).should_receive(:run)
        subject.run
      end
    end
  end
end
