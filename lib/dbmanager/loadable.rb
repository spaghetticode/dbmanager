module Dbmanager
  class Loadable
    include Runner

    def run
      self.target = get_env('target')
      self.filename = get_filename('source', default_filename)

      dumper.run
      output.puts "Database successfully loaded from #{filename}."
    end

    attr_accessor :filename, :target


    private

    def dumper
      adapter::Loader.new(target, filename)
    end

    def adapter
      Dbmanager::Adapters.const_get source.adapter.capitalize
    end

    def default_filename
      Dbmanager.rails_root.join "tmp/#{source.database}.sql"
    end
  end
end
