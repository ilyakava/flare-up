module FlareUp
  module Command
    class CreateTable < Command::Base

      attr_reader :columns

      def initialize(*args)
        @columns = []
        super
      end


      # http://docs.aws.amazon.com/redshift/latest/dg/r_CREATE_TABLE_NEW.html
      def get_command
        "CREATE TABLE #{@table_name} #{get_columns} #{@options}"
      end

      # a little different than copy... the columns argument will have parentheses
      # (since it specifies a schema, where the datatypes may require parentheses)
      # and will need to be enclosed in quotes, and therefore the argument arrives
      # here as a single membered array. This method corrects this difference between
      # copy and create table by splitting on spaces, so that the columns are stored
      # in the same fashion between the two classes, though they arrive in different
      # forms to this method.
      def columns=(columns)
        raise ArgumentError, 'Columns must be a string' unless columns.is_a?(String)
        columns_separated = columns.split(' ')
        raise ArgumentError, 'Columns must have a data type for each name' unless columns_separated.length % 2 == 0
        @columns = columns_separated
      end

      def execute(connection)
        begin
          connection.execute(get_command)
          []
        rescue PG::InternalError => e
          case e.message
            when /Check 'stl_load_errors' system table for details/
              return STLLoadErrorFetcher.fetch_errors(connection)
            when /PG::SyntaxError/
              matches = /syntax error (.+) \(PG::SyntaxError\)/.match(e.message)
              raise SyntaxError, "Syntax error in the CREATE TABLE command: [#{matches[1]}]."
            else
              raise e
          end
        end
      end

      private

      def get_columns
        return '' if columns.empty?
        name_type_pairs = @columns.each_slice(2).map { |name, type| "#{name} #{type}" }
        "(#{name_type_pairs.join(', ').strip})"
      end
    end
  end
end
