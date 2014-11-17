module FlareUp
  module Command
    class DropTable < Command::Base

      # http://docs.aws.amazon.com/redshift/latest/dg/r_DROP_TABLE.html
      def get_command
        "DROP TABLE #{@table_name} #{@options}"
      end
    end
  end
end
