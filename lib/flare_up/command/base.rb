module FlareUp

  class CommandError < StandardError
  end
  class DataSourceError < CommandError
  end
  class OtherZoneBucketError < CommandError
  end
  class SyntaxError < CommandError
  end

  module Command
    class Base

      attr_reader :table_name

      def initialize(table_name, *args)
        @table_name = table_name
      end

      # Split CamelCase and UPCASE it for error presentation
      def name
        namespaces = self.class.to_s.split('::')
        namespaces.last.split(/(?=[A-Z])/).map { |w| w.upcase }.join(' ')
      end

      def execute(connection)
        begin
          connection.execute(get_command)
          []
        rescue PG::InternalError => e
          case e.message
            when /Check 'stl_load_errors' system table for details/
              return STLLoadErrorFetcher.fetch_errors(connection)
            when /The specified S3 prefix '.+' does not exist/
              raise DataSourceError, "A data source with prefix '#{@data_source}' does not exist."
            when /The bucket you are attempting to access must be addressed using the specified endpoint/
              raise OtherZoneBucketError, "Your Redshift instance appears to be in a different zone than your S3 bucket.  Specify the \"REGION 'bucket-region'\" option."
            when /PG::SyntaxError/
              matches = /syntax error (.+) \(PG::SyntaxError\)/.match(e.message)
              raise SyntaxError, "Syntax error in the #{name} command: [#{matches[1]}]."
            else
              raise e
          end
        end
      end
    end
  end
end
