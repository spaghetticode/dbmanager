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
          "mysqldump #{params} #{ignore_tables} > #{filename}"
        end

        def params
          "-u#{source.username} #{flag :password, :p} #{flag :host, :h} #{flag :port, :P} #{source.database}"
        end

        def ignore_tables
          if source.ignoretables.present?
            source.ignoretables.inject('') do |s, view|
              s << " --ignore-table=#{source.database}.#{view}"
            end
          end
        end

        def flag(name, flag)
          source.send(name).present? ? "-#{flag}#{source.send(name)}" : ''
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
