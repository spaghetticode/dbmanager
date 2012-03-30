module Dbmanager
  module Adapters
    module SomeAdapter
      class Connection
        def initialize(*args); end
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
