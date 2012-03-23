module Dbmanager
  class Dumper
    attr_reader :environments, :source, :adapter, :filename

    def initialize
      @environments = YmlParser.environments
      @adapter      = set_adapter
      @source       = adapter::Connection.new(set_source)
      @filename     = set_filename
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
      get_env
    end

    def set_filename
      puts "\nPlease choose target file (defaults to #{default_filename}\n\n"
      get_filename
    end

    def run
      adapter::Dumper.new(source, filename).run
      puts "Database Dump completed to #{filename}"
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

    def default_filename
      "#{Dbmanager.rails_root.join 'tmp', "#{source.database}.sql"}"
    end

    def get_filename
      filename = STDIN.gets.chomp
      if filename.blank?
        default_filename
      else
        Rails.root.join(filename)
      end
    end
  end
end
