namespace :db do
  desc 'import specific environment db data into another environment db'
  task :import  do
    require 'dbmanager'
    Dbmanager::Runner.run('importable')
  end

  desc 'dump specific environment db data in tmp directory'
  task :dump do
    require 'dbmanager'
    Dbmanager::Runner.run('dumpable')
  end
end
