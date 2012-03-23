module Dbmanager; end

# we're already inside rails, but I want to keep the required code at a minimum,
# just to see how decoupled active_support is now
require 'active_support/deprecation'
require 'active_support/core_ext/module'

require File.expand_path '../dbmanager/yml_parser', __FILE__
require File.expand_path '../dbmanager/adapters/mysql', __FILE__
