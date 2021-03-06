# An +Environment+ object is created for each environment listed in the
# database.yml file.
#
# Common useful options are:
# +ignore_tables+: a list of tables that will not be dumped.
#
# +protected+: makes the environment protected from overwriting.
# By default every environment except for the ones that  contain the
# +production+ string can be overwritten. This is dangerous of course, so you
# can protect an environment from overwriting adding  +protected: true+ to
# that environment in the database.yml file.
# If on the other hand you want to be free to overwrite the production db
# you need to explicitly set +protected: false+ to that environment in the
# database.yml file.

require 'ostruct'

module Dbmanager
  class Environment < OpenStruct

    # verifies whether the environment is protected from overwriting or not.
    def protected?
      if name =~ /production/
        protected != false
      else
        protected == true
      end
    end

    # returns the flag formatted for the requested attribute, if present.
    # env = Environment.new(:password => 'secret')
    # env.flag('password', 'p') # => -psecret
    # env.flag('foo', 'f')      # => nil
    def flag(attribute, flag)
      value = send attribute
      "-#{flag}#{value}" if value.present?
    end
  end
end
