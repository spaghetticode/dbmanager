require 'spec_helper'

module Dbmanager
  describe Dumpable do
    subject do
      Object.new.tap {|o| o.extend Dumpable}
    end

    before do
      subject.stub :output => STDStub.new, :input => STDStub.new
    end

    describe '#run' do
      before do
        subject.stub(
          :get_filename     => 'filename',
          :default_filename => 'defaultname',
          :dumper           => mock.as_null_object
        )
      end

      it 'sends expected output' do
        subject.run
        [
          'Please choose target file (defaults to defaultname):',
          'Database successfully dumped in filename file.'
        ].each do |message|
          subject.output.content.should include(message)
        end
      end

      it 'delegates the actual dumping to the dumper' do
        subject.send(:dumper).should_receive(:run)
        subject.run
      end
    end
  end
end
