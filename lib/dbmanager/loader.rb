module Dbmanager
  class Loader < Runner

    attr_accessor :filename, :target

    def run
      get_data
      loader.run
      output.puts "Database successfully loaded from #{filename}."
    end

    private

    def get_data
      self.target   = get_env('target')
      self.filename = get_filename('source', default_filename)
    end

    def loader
      adapter::Loader.new(target, filename)
    end

    def adapter
      Dbmanager::Adapters.const_get target.adapter.capitalize
    end

    def default_filename
      Dbmanager.rails_root.join "tmp/#{target.database}.sql"
    end
  end
end
