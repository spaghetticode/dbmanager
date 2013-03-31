module Dbmanager
  class Importer < Runner

    attr_accessor :target, :source

    def run
      get_data
      raise EnvironmentProtectedError if target.protected?
      execute_import
      output.puts 'Database Import completed.'
    end

    def get_data
      self.source = get_env('source')
      self.target = get_env('target')
    end

    def execute_import
      adapter::Importer.new(source, target, tmp_file).run
    end

    def adapter
      raise MixedAdapterError if source.adapter != target.adapter
      Dbmanager::Adapters.const_get source.adapter.capitalize
    end

    def tmp_file
      @tmp_file ||= File.join Dbmanager.rails_root, 'tmp', Time.now.strftime('%y%m%d%H%M%S')
    end
  end
end
