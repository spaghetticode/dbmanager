module Dbmanager
  class Runner
    attr_reader :environments, :source, :adapter

    def self.run
      new.run
    end

    def initialize
      @environments = YmlParser.environments
      @adapter      = set_adapter
      @source       = adapter::Connection.new(set_source)
    end

    def set_adapter
      adapters = @environments.map {|name, env| env.adapter}.uniq
      if adapters.size > 1
        raise AdapterError
      else
        Dbmanager::Adapters.const_get adapters.first.capitalize
      end
    end

    def set_source
      puts "\nPlease choose source db:\n\n"
      get_env
    end

    def get_env
      environments.keys.each_with_index do |name, i|
        puts "#{i+1}) #{name}"
      end
      pos = ''
      until (1..environments.size).include? pos
        pos = STDIN.gets.chomp.to_i
      end
      environments.values[pos-1]
    end
  end
end
