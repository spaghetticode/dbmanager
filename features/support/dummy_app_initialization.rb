# makes sure the dummy app is properly initialized:
# bundles required gems
# creates the databases
# migrates the development database
# dumps db structure for reference
# remove sql dumps in tmp dir

DUMMY_PATH = '../../../spec/dummy'
Dir.chdir File.expand_path(DUMMY_PATH, __FILE__) do
 system 'bundle install'
 system 'bundle exec rake db:create:all'
 system 'bundle exec rake db:migrate'
 system 'bundle exec rake db:structure:dump'
 system 'rm -f tmp/*sql'
end
