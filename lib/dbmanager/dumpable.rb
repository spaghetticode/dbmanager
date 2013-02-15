# Extends the runner with database dumping capabilities.
#
# The user will be prompted to enter the target filename path, pressing enter
# will set it to the default which is the value returned by #default_filename.
#
# The dump process happens in the #run method, and is eventually delegated to
# the specific database adapter which must implement the #run method.

module Dbmanager
  class Dumpable
    include Runnable

    def run
      self.source = get_env('source')
      self.filename = get_filename('target', default_filename)

      dumper.run
      output.puts "Database successfully dumped in #{filename} file."
    end

    attr_accessor :filename, :source


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
  end
end
