module FlareUp
  module Command
    class DropTable < Command::Base

      # http://docs.aws.amazon.com/redshift/latest/dg/r_DROP_TABLE.html
      def get_command
        "DROP TABLE #{@table_name} #{@options}"
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
              raise SyntaxError, "Syntax error in the DROP TABLE command: [#{matches[1]}]."
            else
              raise e
          end
        end
      end
    end
  end
end
