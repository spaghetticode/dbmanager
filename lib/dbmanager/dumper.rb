module Dbmanager
  class Dumper < Runner
    attr_reader :filename

    def initialize
      super
      @filename = set_filename
    end

    def run
      adapter::Dumper.new(source, filename).run
      puts "Database Dump completed to #{filename}"
    end

    private

    def set_filename
      puts "\nPlease choose target file (defaults to #{default_filename}\n\n"
      get_filename
    end

    def default_filename
      "#{Dbmanager.rails_root.join 'tmp', "#{source.database}.sql"}"
    end

    def get_filename
      filename = STDIN.gets.chomp
      filename.blank? ? default_filename : Dbmanager.rails_root.join(filename)
    end
  end
end
