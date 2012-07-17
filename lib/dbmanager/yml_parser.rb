require 'erb'
require 'yaml'
require 'active_support/core_ext/hash'

module Dbmanager
  module YmlParser
    extend self

    class YmlInvalidError < StandardError; end

    def config
      @config ||= yml_load(db_config_file).deep_merge(override_config)
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
        yml_sorted_envs.each_with_object(ActiveSupport::OrderedHash.new) do |arr, hash|
          env_name, env_config = arr[0], arr[1]
          begin
            hash[env_name] = Environment.new env_config.merge(:name => env_name)
          rescue NoMethodError
            raise YmlInvalidError, invalid_message(env_name, env_config)
          end
        end
      end
    end

    private

    def yml_sorted_envs
      config.select do |key, value|
        value.has_key?('adapter')
      end.sort
    end

    def yml_load(path)
      YAML.load(ERB.new(File.read(path)).result) || {}
    end

    def db_config_file
      File.join Dbmanager.rails_root, 'config', 'database.yml'
    end

    def db_override_file
      File.join Dbmanager.rails_root, 'config', 'dbmanager_override.yml'
    end

    def invalid_message(env_name, config)
      message = "\"#{env_name}\" config seems to be corrupted:\n#{config.inspect}"
      message << "\nPlease verify database.yml file (original error: #{$!.message})"
    end
  end
end
