# Teaches how to dump a database to the runner.
module Dbmanager
  module Dumpable
    def self.extended(base)
      class << base; attr_accessor :filename; end
    end

    def run
      output.puts "\nPlease choose target file (defaults to #{default_filename}):\n\n"
      @filename = get_filename
      dumper.run
      output.puts "Database successfully dumped in #{filename} file."
    end

    private

    def dumper
      adapter::Dumper.new(source, filename)
    end

    def adapter
      Dbmanager::Adapters.const_get source.adapter.capitalize
    end

    def default_filename
      Dbmanager.rails_root.join "tmp/#{source.database}.sql"
    end

    def get_filename
      filename = input.gets.chomp
      filename.blank? ? default_filename : Dbmanager.rails_root.join(filename)
    end
  end
end
