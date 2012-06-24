module Dbmanager
  module Importable
    attr_reader :target

    def initialize(input=STDIN, output=STDOUT)
      super
      @target = set_env('target')
    end

    def run
      adapter::Importer.new(source, target).run
      output.puts 'Database Import completed.'
    end

    private

    def adapter
      raise MixedAdapterError if source.adapter != target.adapter
      Dbmanager::Adapters.const_get source.adapter.capitalize
    end
  end
end
