module Dbmanager
  class AdapterError < StandardError
    def initialize(message)
      super message || 'You cannot mix different adapters'
    end
  end

  if defined? Rails and Rails.version.to_f >= 3
    class Engine < Rails::Engine; end
  end

  extend self

  def rails_root
    Rails.root
  end

  def execute(command)
    system command
  end
end

require 'active_support/deprecation'
require 'active_support/core_ext/module'

%w[yml_parser adapters/mysql runner importer dumper].each do |string|
  require File.expand_path "../dbmanager/#{string}", __FILE__
end
