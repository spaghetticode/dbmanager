# The runner main responsibility is to interact with the user in order to gather
# the information to accomplish the task.
#
# The runner object cannot do much when freshly instantiated, so for each kind
# of available task there is a corresponding module that can extend the runner
# so that it can accomplish its goal.
#
# Extension modules must define the #run method which contains the specific
# behaviour they provide.

module Dbmanager
  module Runnable
    attr_reader :input, :output, :environments

    def self.run
      new.run
    end

    def initialize(input=STDIN, output=STDOUT)
      @input        = input
      @output       = output
      @environments = YmlParser.environments
    end

    def get_env(type)
      output.puts "\nPlease choose #{type} db:\n\n"
      get_environment
    end

    def get_filename type, default_filename
      output.print "\nPlease choose #{type} file (defaults to #{default_filename}): "
      filename = get_input
      filename.blank? ? default_filename : Dbmanager.rails_root.join(filename)
    end


    private

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
