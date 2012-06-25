module Dbmanager
  module Adapters
    module SomeAdapter
      class Connection
        attr_reader :protected

        def initialize(*args); end

        def protected?
          protected == true
        end
      end

      class Dumper
        def initialize(*args); end

        def run; end
      end

      class Importer
        def initialize(*args); end

        def run; end
      end
    end
  end
end
