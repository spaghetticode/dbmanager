if defined?(Capistrano::Version) && Gem::Version.new(Capistrano::Version).release >= Gem::Version.new("3.0")
  raise 'Capistrano 3 is not supported yet!'
end

Capistrano::Configuration.instance(:must_exist).load do
  # Those config vars can be overridden in your recipes
  # in order to customize the dbmanager settings:
  _cset :dbmanager_remote_env, lambda {
    Dbmanager::YmlParser.environments[rails_env.to_s]
  }

  _cset :dbmanager_local_env, lambda {
    Dbmanager::YmlParser.environments[Rails.env]
  }

  namespace :db do
    task :import do
      require 'config/environment.rb'
      require 'active_support/core_ext'
      require 'dbmanager'
      require 'open3'

      dumper = Dbmanager::Adapters::Mysql::Dumper.new(dbmanager_remote_env, '/dev/stdout')
      loader = Dbmanager::Adapters::Mysql::Loader.new(dbmanager_local_env, '/dev/stdin')
      dumper.mysqldump_version = dumper.extract_version capture('mysqldump --version')
      Open3.popen3 loader.load_command do |input, output, error|
        begin
          run dumper.dump_command_ssh do |channel, stream, data|
            input << data if stream == :out
            raise data    if stream == :err
          end
          input.close
        ensure
          output.read.tap { |s| puts "OUT: #{s}" unless s.empty? }
          error.read.tap  { |s| puts "ERR: #{s}" unless s.empty? }
        end
      end
    end

    task :export do
      require 'config/environment.rb'
      require 'active_support/core_ext'
      require 'dbmanager'

      dumper = Dbmanager::Adapters::Mysql::Dumper.new(dbmanager_local_env, '')
      loader = Dbmanager::Adapters::Mysql::Loader.new(dbmanager_remote_env, '')

      raise Dbmanager::EnvironmentProtectedError if loader.target.protected?

      address = "#{fetch :user}@#{roles[:web].first.host}"
      command = "#{dumper.dump_command_ssh} | ssh #{address} '#{loader.load_command_ssh}'"
      puts "executing #{command}..."
      system command
    end
  end
end