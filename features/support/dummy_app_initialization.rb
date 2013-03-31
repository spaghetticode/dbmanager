# makes sure the dummy app is properly initialized:
# bundles required gems
# drops/creates the databases
# migrates the development database
# dumps db structure for reference
# removes old sql dumps in tmp dir

STDIN_STUB = 'STDIN_stub'
DUMMY_PATH = '../../../spec/dummy'
Dir.chdir File.expand_path(DUMMY_PATH, __FILE__) do
  system 'mkdir tmp'
  system 'bundle install'
  system 'rm -f tmp/*sql'
  %w[
    db:drop:all
    db:create:all
    db:migrate
    db:structure:dump
  ].each do |command|
    system "bundle exec rake #{command}"
  end
end
