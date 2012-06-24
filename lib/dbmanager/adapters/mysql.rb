require 'time'

module Dbmanager
  module Adapters
    module Mysql
      class Dumper
        attr_reader :source, :filename

        def initialize(source, filename)
          @source   = source
          @filename = filename
        end

        def run
          Dbmanager.execute! dump_command
        end

        def dump_command
          "mysqldump #{ignoretables} #{params} > #{filename}"
        end

        def params
          "-u#{source.username} #{flag :password, :p} #{flag :host, :h} #{flag :port, :P} #{source.database}"
        end

        def flag(attribute, flag)
          value = source.send attribute
          value.present? ? "-#{flag}#{value}" : ''
        end

        def ignoretables
          if source.ignoretables.present?
            source.ignoretables.inject [] do |arr, table|
              arr << "--ignore-table=#{source.database}.#{table}"
            end.join ' '
          end
        end
      end

      class Importer
        attr_reader :source, :target

        def initialize(source, target)
          @source = source
          @target = target
        end

        def run
          Dumper.new(source, temp_file).run
          Dbmanager.execute! import_command
        ensure
          remove_temp_file
        end

        def import_command
          unless target.protected?
            "mysql #{target.params} < #{temp_file}"
          else
            raise EnvironmentProtectedError
          end
        end

        def remove_temp_file
          Dbmanager.execute "rm #{temp_file}"
        end

        def temp_file
          @temp_file ||= "/tmp/#{Time.now.strftime '%y%m%d%H%M%S'}"
        end
      end
    end
  end
end
