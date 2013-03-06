module Dbmanager
  module Runnable
    attr_reader :input, :output, :environments

    def initialize(input=STDIN, output=STDOUT)
      @input        = input
      @output       = output
      @environments = YmlParser.environments
    end

    def get_env(type)
      output.puts "\nPlease choose #{type} db:\n\n"
      get_environment
    end

    def get_filename(type, default_filename)
      output.print "\nPlease choose #{type} file (defaults to #{default_filename}): "
      filename = get_input
      if filename.blank?
        default_filename
      else
        absolute_path(filename)
      end
    end

    private

    def absolute_path(filename)
      if filename[0].chr == '/'
        filename
      else
        Dbmanager.rails_root.join(filename)
      end
    end

    def get_environment
      environments.keys.each_with_index do |name, i|
        output.puts "#{i+1}) #{name}"
      end
      output.puts
      pos = ''
      until (1..environments.size).include? pos
        pos = get_input.to_i
      end
      environments.values[pos-1]
    end

    def get_input
      input.gets.to_s.strip
    end
  end
end
