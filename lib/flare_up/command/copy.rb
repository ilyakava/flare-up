module FlareUp
  module Command
    class Copy < Command::Base

      attr_reader :data_source
      attr_reader :aws_access_key_id
      attr_reader :aws_secret_access_key
      attr_accessor :options
      attr_reader :columns

      def initialize(table_name, data_source, aws_access_key_id, aws_secret_access_key)
        @data_source = data_source
        @aws_access_key_id = aws_access_key_id
        @aws_secret_access_key = aws_secret_access_key
        @options = ''
        @columns = []
        super
      end

      # http://docs.aws.amazon.com/redshift/latest/dg/r_COPY.html
      def get_command
        "COPY #{@table_name} #{get_columns} FROM '#{@data_source}' CREDENTIALS '#{get_credentials}' #{@options}"
      end

      def columns=(columns)
        raise ArgumentError, 'Columns must be an array' unless columns.is_a?(Array)
        @columns = columns
      end

      private

      def get_columns
        return '' if columns.empty?
        "(#{@columns.join(', ').strip})"
      end

      def get_credentials
        "aws_access_key_id=#{@aws_access_key_id};aws_secret_access_key=#{@aws_secret_access_key}"
      end
    end
  end
end
