module Dbmanager
  class Importer < Runner
    attr_reader :target

    def initialize(input=STDIN, output=STDOUT)
      super
      @target = adapter::Connection.new(set_target)
    end

    def run
      adapter::Importer.new(source, target).run
      output.puts 'Database Import completed.'
    end

    private

    def set_target
      output.puts "\nPlease choose target db:\n\n"
      get_env
    end
  end
end
