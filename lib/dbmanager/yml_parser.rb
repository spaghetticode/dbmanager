require 'erb'
require 'yaml'
require 'ostruct'

module Dbmanager
  module YmlParser
    class Environment < OpenStruct; end

    extend self

    attr_writer :config

    def config
      @config ||= YAML.load db_config_file_parsed
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
          hash[arr[0]] = Environment.new arr[1]
        end
      end
    end

    private

    def db_config_file_parsed
      ERB.new(File.read(db_config_file)).result
    end

    def db_config_file
      if Rails.defined?
        Rails.root.join 'config', 'database.yml'
      else
        raise 'no database.yml file found in the expected dir!'
      end
    end
  end
end
