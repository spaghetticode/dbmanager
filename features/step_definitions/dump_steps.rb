When /^I interactively execute "(.*?)"$/ do |command|
  system command
end

Then /^an? sql dump should be created in "(.*?)"$/ do |path|
  File.file?(path).should be_true
end

Then /^the dump file should have expected schema$/ do
  File.open('db/structure.sql').each do |line|
    dump_file.should include(line) unless line =~ /INSERT INTO schema_migrations/
  end
end

Then /^the dump file should include "(.*?)"$/ do |string|
  dump_file.should include(string)
end

def dump_file
  File.read('tmp/dbmanager_dummy_dev.sql')
end