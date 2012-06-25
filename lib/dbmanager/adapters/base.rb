module Dbmanager
  module Adapters
    module Base
      class Connection
        attr_reader :environment

        delegate :name, :protected, :to => :environment

        def initialize environment
          @environment = environment
        end

        def protected?
          if name =~ /production/
            protected != false
          else
            protected == true
          end
        end
      end
    end
  end
end