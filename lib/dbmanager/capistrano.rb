_cset :dbmanager_remote_env, lambda {
  Dbmanager::YmlParser.environments[rails_env.to_s]
}


_cset :dbmanager_local_env, lambda {
  Dbmanager::YmlParser.environments[Rails.env]
}


namespace :db do
  task :import do
    require File.expand_path('../environment', __FILE__)
    require 'dbmanager'
    require 'open3'

    dumper = Dbmanager::Adapters::Mysql::Dumper.new(dbmanager_remote_env, '/dev/stdout')
    loader = Dbmanager::Adapters::Mysql::Loader.new(dbmanager_local_env, '/dev/stdin')
    dumper.mysqldump_version = dumper.extract_version capture('mysqldump --version')

    Open3.popen3 loader.load_command do |input, output, error|
      begin
        run dumper.dump_command do |channel, stream, data|
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
end
