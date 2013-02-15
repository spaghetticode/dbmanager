namespace :db do
  desc 'import specific environment db data into another environment db'
  task :import  do
    require 'dbmanager'
    Dbmanager::Runnable.run(:importable)
  end

  desc 'dump specific environment db data to a file'
  task :dump do
    require 'dbmanager'
    Dbmanager::Runnable.run(:dumpable)
  end

  desc 'load specific environment db data from a file'
  task :load do
    require 'dbmanager'
    Dbmanager::Runnable.run(:loadable)
  end
end
