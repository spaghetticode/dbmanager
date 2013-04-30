require 'active_support/all'

module Dbmanager
  autoload :Environment, 'dbmanager/environment'
  autoload :YmlParser,   'dbmanager/yml_parser'
  autoload :Runner,      'dbmanager/runner'
  autoload :Importer,    'dbmanager/importer'
  autoload :Dumper,      'dbmanager/dumper'
  autoload :Loader,      'dbmanager/loader'
  autoload :Adapters,    'dbmanager/adapters'

  class EnvironmentProtectedError < StandardError
    def initialize(message=nil)
      super message || 'sorry the environment is protected from writing'
    end
  end

  class MixedAdapterError < StandardError
    def initialize(message=nil)
      super message || 'You cannot mix different adapters!'
    end
  end

  class CommandError < StandardError
    def initialize(message=nil)
      super message || 'Could not execute command!'
    end
  end

  if defined? Rails and Rails.version.to_f >= 3
    class Engine < Rails::Engine; end
  end

  extend self

  def rails_root
    Rails.root
  end

  def execute(command, output=$stdout)
    execute!(command, output) rescue false
  end

  def execute!(command, output=$stdout)
    output.puts %(executing "#{command}")
    result = `#{command}`
    $?.exitstatus.zero? ? result : raise(CommandError)
  end
end
