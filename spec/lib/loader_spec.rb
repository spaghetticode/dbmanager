require 'spec_helper'

module Dbmanager
  describe Loader do
    subject  { described_class.new }

    describe '#run' do
      before do
        stub_rails_root
        subject.stub(
          :dumper           => mock,
          :input            => STDStub.new,
          :output           => STDStub.new,
          :get_filename     => 'filename',
          :default_filename => 'default_filename',
          :loader           => mock.as_null_object,
          :get_env          => Environment.new(:name => 'beta', :adapter => 'mysql2')
        )
        Dbmanager.stub!(:execute! => nil)
      end

      it 'sends expected output' do
        subject.send(:dumper).stub(:run => nil)
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
