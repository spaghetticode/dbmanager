module Dbmanager
  class Dumper < Runner
    attr_reader :filename

    def initialize(input=STDIN, output=STDOUT)
      super
      @filename = set_filename
    end

    def run
      adapter::Dumper.new(source, filename).run
      output.puts "Database Dump completed to #{filename}"
    end

    private

    def set_filename
      output.puts "\nPlease choose target file (defaults to #{default_filename})\n\n"
      get_filename
    end

    def default_filename
      "#{Dbmanager.rails_root.join 'tmp', "#{source.database}.sql"}"
    end

    def get_filename
      filename = input.gets.chomp
      filename.blank? ? default_filename : Dbmanager.rails_root.join(filename)
    end
  end
end
