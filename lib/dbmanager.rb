require 'active_support/deprecation'
require 'active_support/core_ext/module'
require 'active_support/ordered_hash'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'

module Dbmanager
  autoload :Environment, 'dbmanager/environment'
  autoload :YmlParser,   'dbmanager/yml_parser'
  autoload :Runnable,     'dbmanager/runnable'
  autoload :Importable,  'dbmanager/importable'
  autoload :Dumpable,    'dbmanager/dumpable'
  autoload :Loadable,    'dbmanager/loadable'
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

  def execute(command, output=STDOUT)
    output.puts %(executing "#{command}")
    system command
  end

  def execute!(command)
    execute(command) or raise CommandError
  end
end
