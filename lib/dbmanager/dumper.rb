module Dbmanager
  class Dumper
    include Runnable

    attr_accessor :filename, :source

    def run
      get_data
      dumper.run
      output.puts "Database successfully dumped in #{filename} file."
    end

    private

    def get_data
      self.source = get_env('source')
      self.filename = get_filename('target', default_filename)
    end

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
