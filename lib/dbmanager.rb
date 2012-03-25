module Dbmanager
  class AdapterError < StandardError
    def initialize(message)
      super message || 'You cannot mix different adapters'
    end
  end

  if defined? Rails and Rails.version.to_f >= 3
    class Engine < Rails::Engine
    end
  end

  extend self

  def rails_root
    Rails.root
  end

  def execute(command)
    system command
  end
end

# we're already inside rails, but I want to keep the required code at a minimum,
# just to see how decoupled active_support is now
require 'active_support/deprecation'
require 'active_support/core_ext/module'

require File.expand_path '../dbmanager/yml_parser', __FILE__
require File.expand_path '../dbmanager/adapters/mysql', __FILE__
require File.expand_path '../dbmanager/runner', __FILE__
require File.expand_path '../dbmanager/importer', __FILE__
require File.expand_path '../dbmanager/dumper', __FILE__
