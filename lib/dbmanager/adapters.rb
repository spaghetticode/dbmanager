module Dbmanager
  module Adapters
    autoload :Mysql,  'dbmanager/adapters/mysql'
    autoload :Mysql2, 'dbmanager/adapters/mysql2'
  end
end
