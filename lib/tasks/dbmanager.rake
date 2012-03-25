namespace :db do
  desc 'import specific environment db data into another environment db'
  task :import  do
    Dbmanager::Importer.run
  end

  desc 'dump specific environment db data in tmp directory'
  task :dump do
    Dbmanager::Dumper.run
  end
end
