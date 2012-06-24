# makes sure the dummy app is properly initialized:
# bundles required gems
# creates the databases
# migrates the development database

Dir.chdir File.expand_path('../../../dummy', __FILE__) do
  system 'bundle install'
  system 'bundle exec rake db:create:all'
  system 'bundle exec rake db:migrate'
end
