Given /^I go to the dummy rails app folder$/ do
  Dir.chdir File.expand_path('../../../dummy', __FILE__)
end

When /^I execute "(.*?)"$/ do |command|
  @output = `#{command}`
end

Then /^I should see "(.*?)" among the listed tasks$/ do |task_name|
  @output.should include(task_name)
end

