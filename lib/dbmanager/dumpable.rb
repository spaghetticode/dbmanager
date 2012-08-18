# Extends the runner with database dumping capabilities.
#
# The user will be prompted to enter the target filename path, pressing enter
# will set it to the default which is the value returned by #default_filename.
#
# The dump process happens in the #run method, and is eventually delegated to
# the specific database adapter which must implement the #run method.

module Dbmanager
  module Dumpable
    def self.extended(base)
      class << base; attr_accessor :filename; end
    end

    def run
      output.print "\nPlease choose target file (defaults to #{default_filename}): "
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
