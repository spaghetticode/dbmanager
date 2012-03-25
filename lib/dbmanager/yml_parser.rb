require 'erb'
require 'yaml'
require 'ostruct'

# TODO: override values

module Dbmanager
  module YmlParser
    class Environment < OpenStruct; end

    extend self
    attr_writer :config

    def config
      @config ||= yml_load(db_config_file).merge(override_config)
    end

    def override_config
      File.file?(db_override_file) ? yml_load(db_override_file) : {}
    end

    def reload_config
      @config = nil
      config
    end

    def environments
      @environments ||= begin
        config.select do |key, value|
          value.has_key?('adapter')
        end.each_with_object({}) do |arr, hash|
          hash[arr[0]] = Environment.new arr[1].merge(:name => arr[0])
        end
      end
    end

    private

    def yml_load(path)
      YAML.load ERB.new(File.read(path)).result
    end

    def db_config_file
      File.join Dbmanager.rails_root, 'config', 'database.yml'
    end

    def db_override_file
      File.join Dbmanager.rails_root, 'config', 'dbmanager_override.yml'
    end
  end
end
