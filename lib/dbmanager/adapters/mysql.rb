require 'time'

module Dbmanager
  module Adapters
    module Mysql
      module Connectable
        def params(environment)
          [ "-u#{environment.username}",
            environment.flag(:password, :p),
            environment.flag(:host, :h),
            environment.flag(:port, :P),
            environment.database
          ].compact.join(' ')
        end
      end

      class Dumper
        include Connectable
        attr_reader :source, :filename
        attr_writer :mysqldump_version

        def initialize(source, filename)
          @source   = source
          @filename = filename
        end

        def run
          Dbmanager.execute! dump_command
        end

        def mysqldump_version
          @mysqldump_version ||= extract_version Dbmanager.execute('mysqldump --version')
        end

        def extract_version(version)
          version =~ /Distrib\s+(\d+\.\d+)/
          $1.to_f
        end

        def dump_command
          "mysqldump #{ignoretables} #{set_gtid_purged_off} #{params(source)} > '#{filename}'"
        end

        def dump_command_ssh
          "mysqldump #{ignoretables} #{set_gtid_purged_off} #{params(source)}"
        end

        def ignoretables
          if source.ignoretables.present?
            source.ignoretables.inject [] do |arr, table|
              arr << "--ignore-table=#{source.database}.#{table}"
            end.join ' '
          end
        end

        private

        # Extra parameter to fix a 5.6 mysqldump issue with older mysql server releases
        # See http://bugs.mysql.com/bug.php?id=68314
        def set_gtid_purged_off
          mysqldump_version >= 5.6 ? '--set-gtid-purged=OFF' : ''
        end
      end

      class Loader
        include Connectable
        attr_reader :target, :tmp_file

        def initialize(target, tmp_file)
          @target   = target
          @tmp_file = tmp_file
        end

        def run
          create_db_if_missing
          load
        end

        def create_db_if_missing
          Dbmanager.execute! create_db_if_missing_command
        end

        def load
          Dbmanager.execute! load_command
        end

        def load_command
          "mysql #{params(target)} < '#{tmp_file}'"
        end

        def load_command_ssh
          "mysql #{params target}"
        end

        def create_db_if_missing_command
          "bundle exec rake db:create RAILS_ENV=#{target.name}"
        end
      end

      class Importer
        include Connectable
        attr_reader :source, :target, :tmp_file

        def initialize(source, target, tmp_file)
          @source   = source
          @target   = target
          @tmp_file = tmp_file
        end

        def run
          Dumper.new(source, tmp_file).run
          Loader.new(target, tmp_file).run
        ensure
          remove_tmp_file
        end

        def remove_tmp_file
          Dbmanager.execute "rm '#{tmp_file}'"
        end
      end
    end
  end
end
