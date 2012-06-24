module Dbmanager
  module Importable
    def self.extended(base)
      class << base; attr_reader :target; end
    end

    def run
      @target = get_env('target')
      execute_import
      output.puts 'Database Import completed.'
    end

    def execute_import
      adapter::Importer.new(source, target).run
    end

    def adapter
      raise MixedAdapterError if source.adapter != target.adapter
      Dbmanager::Adapters.const_get source.adapter.capitalize
    end
  end
end
