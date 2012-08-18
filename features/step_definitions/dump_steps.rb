When /^I interactively execute "(.*?)"$/ do |command|
  system command
end

Then /^an sql dump should be created in "(.*?)"$/ do |path|
  File.file?(path).should be_true
end

Then /^the dump file should include expected schema$/ do
  dump = File.read('tmp/dbmanager_dummy_dev.sql')
  File.open('db/structure.sql').each do |line|
    dump.should include(line)
  end
end
