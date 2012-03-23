module Dbmanager
  class Importer
    class AdapterError < StandardError; end

    attr_reader :environments, :source, :target, :adapter
    PROTECTED_ENVS = %w[production]

    def initialize
      @environments = YmlParser.environments
      @adapter = set_adapter
      puts @adapter
      @source  = adapter::Connection.new(set_source)
      @target  = adapter::Connection.new(set_target)
      run
    end

    def set_adapter
      adapters = @environments.map {|name, env| env.adapter}.uniq
      if adapters.size > 1
        raise AdapterError, 'You cannot mix different adapters'
      else
        Dbmanager::Adapters.const_get adapters.first.capitalize
      end
    end

    def set_source
      puts "\nPlease choose source db:\n\n"
      get_env(:source)
    end

    def set_target
      puts "\nPlease choose target db:\n\n"
      get_env(:target)
    end

    def get_env(type)
      environments.keys.each_with_index do |name, i|
        puts "#{i+1}) #{name}"
      end
      pos = ''
      until (1..environments.size).include? pos
        pos = STDIN.gets.chomp.to_i
        if type == :target and PROTECTED_ENVS.include? @environments.keys[pos-1]
          puts "Cannot let you overwrite protected database.\nChoose again\n\n"
          pos = ''
        end
      end
      environments.values[pos-1]
    end

    def run
      adapter::Importer.new(source, target).run
      puts "Database Import completed."
    end
  end
end
