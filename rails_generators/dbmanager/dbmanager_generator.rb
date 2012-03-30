class DbmanagerGenerator < Rails::Generator::Base
  RAKE_FILENAME  = 'dbmanager.rake'
  RAKE_FILE_PATH = File.expand_path "../../../lib/tasks/#{RAKE_FILENAME}", __FILE__

  def manifest
    record do |m|
      rails_rake_file = Rails.root.join 'lib/tasks', RAKE_FILENAME
      contents = File.readlines(RAKE_FILE_PATH).unshift(lib_requires)
      File.open(rails_rake_file, 'w') {|f| f.puts contents.join}
      print_message
    end
  end

  private

  def lib_requires
    "require '#{File.expand_path('../../../lib', __FILE__)}/dbmanager.rb'\n\n"
  end

  def print_message
    message = "Rake file copied to #{rails_rake_file}"
    puts "*"*message.size
    puts message
    puts "*"*message.size
  end

  def banner
    <<-EOS
Adds dbmanager rake file to yout rails 2.x application

USAGE: #{$0} #{spec.name}
EOS
  end
end
