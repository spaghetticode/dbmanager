require 'time'

module Dbmanager
  module Adapters
    module Mysql
      class Connection
        attr_reader :environment

        delegate :host, :adapter, :database, :username, :password, :port, :encoding, :to => :environment

        def initialize(environment)
          @environment = environment
        end

        def params
          "-u#{username} #{flag :password, :p} #{flag :host, :h} #{flag :port, :P} #{database}"
        end

        def flag(name, flag)
          send(name).present? ? "-#{flag}#{send(name)}" : ''
        end
      end

      class Dumper
        attr_reader :source, :filename

        def initialize(source, filename)
          @source   = source
          @filename = filename
        end

        def run
          system dump_command
        end

        def dump_command
          "mysqldump #{source.params} > #{filename}"
        end
      end

      class Importer
        attr_reader :source, :target

        def initialize(source, target)
          @source = source
          @target = target
        end

        def run
          Dumper.new(source, temp_sql_file).run
          system import_command
          # remove temporary file?
        end

        def import_command
          "mysql #{target.params} < #{temp_sql_file}"
        end

        def temp_sql_file
          @temp_sql_file ||= "/tmp/#{Time.now.strftime '%y%m%d%H%M%S'}"
        end
      end
    end
  end
end
