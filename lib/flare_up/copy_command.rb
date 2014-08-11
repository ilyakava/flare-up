module FlareUp

  class CopyCommandError < StandardError
  end
  class DataSourceError < CopyCommandError
  end
  class OtherZoneBucketError < CopyCommandError
  end

  class CopyCommand

    attr_reader :table_name
    attr_reader :data_source
    attr_reader :aws_access_key_id
    attr_reader :aws_secret_access_key
    attr_reader :columns
    attr_accessor :options

    def initialize(table_name, data_source, aws_access_key_id, aws_secret_access_key)
      @table_name = table_name
      @data_source = data_source
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
      @columns = []
      @options = ''
    end

    def get_command
      "COPY #{@table_name} #{get_columns} FROM '#{@data_source}' CREDENTIALS '#{get_credentials}' #{@options}"
    end

    def columns=(columns)
      raise ArgumentError, 'Columns must be an array' unless columns.is_a?(Array)
      @columns = columns
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
          else
            raise e
        end
      end
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