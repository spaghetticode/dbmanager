require 'spec_helper'

module Dbmanager
  module Adapters
    module Base
      describe Connection do
        before { stub_rails_root }

        describe 'a base abstract connection definition' do
          subject { Connection.new Dbmanager::YmlParser.environments['test'] }

          it 'delegates "protected" to environment object' do
            subject.protected.should == subject.environment.protected
          end

          it 'delegates "name" to environment object' do
            subject.name.should == subject.environment.name
          end

          describe '#protected?' do
            it 'is false by default' do
              subject.should_not be_protected
            end

            context 'when name matches production string' do
              it 'is true by default ' do
                subject.stub! :name => 'production-merge'
                subject.should be_protected
              end

              context 'when protected is set to false' do
                it 'is false' do
                  subject.stub! :name => 'production', :protected => false
                  subject.should_not be_protected
                end
              end
            end
          end

        end
      end
    end
  end
end