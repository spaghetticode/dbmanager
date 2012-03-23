namespace :db do
  desc 'dump an environment db data into another environment'
  task :dump  do
    Dbmanager::Importer.new
  end
end
