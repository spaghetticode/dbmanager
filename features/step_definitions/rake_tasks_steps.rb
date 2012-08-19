Given /^I go to the dummy rails app folder$/ do
  Dir.chdir File.expand_path(DUMMY_PATH, __FILE__)
end

When /^I execute "(.*?)"$/ do |command|
  @output = `#{command}`
end

Then /^I should see "(.*?)" among the listed tasks$/ do |task_name|
  @output.should include(task_name)
end

When /^I run the task "(.*?)" with input "(.*?)"$/ do |task, params|
  File.open STDIN_STUB, 'w' do |f|
    params.split(' ').each {|param| f.puts param}
  end
  step "I execute \"rake #{task} < #{STDIN_STUB}\""
end
