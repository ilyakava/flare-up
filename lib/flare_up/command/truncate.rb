module FlareUp
  module Command
    class Truncate < Command::Base

      # http://docs.aws.amazon.com/redshift/latest/dg/r_TRUNCATE.html
      def get_command
        "TRUNCATE #{@table_name}"
      end
    end
  end
end
