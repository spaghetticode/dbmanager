Then /^data should be loaded into the development database$/ do
  #
end

Then /^the "(.*?)" database should include a friend named "(.*?)"$/ do |env, name|
  names = `RAILS_ENV=#{env} bundle exec rails runner 'puts Friend.all.map(&:name)'`
  names.should include name
end