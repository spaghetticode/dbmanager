module Dbmanager
  class AdapterError < StandardError
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

require 'active_support/deprecation'
require 'active_support/core_ext/module'

%w[yml_parser adapters/mysql runner importer dumper].each do |string|
  require File.expand_path "../dbmanager/#{string}", __FILE__
end
