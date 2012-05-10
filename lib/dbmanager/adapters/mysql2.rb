# just the same as the mysql adapter, but ready for modifications

module Dbmanager
  module Adapters
    module Mysql2
      include Mysql
    end
  end
end
