class DbmanagerGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      rakefile_path = Rails.root.join 'Rakefile'
      unless File.readlines(rakefile_path).include? rakefile_addon
        File.open(rakefile_path, 'a') { |f| f.puts rakefile_addon }
      end
    end
 end

  protected

  def rakefile_addon
    path = File.expand_path('../../../lib', __FILE__)
    "\n#added by dbmanager generator\nrequire '#{path}/dbmanager.rb'\nimport '#{path}/tasks/dbmanager.rake'"
  end

  def banner
    <<-EOS
Adds required paths to your rails 2.x Rakefile

USAGE: #{$0} #{spec.name}
EOS
  end
end
