module FlareUp

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
      rescue PG::InternalError => e
        if e.message =~ /Check 'stl_load_errors' system table for details/
          return STLLoadErrorFetcher.fetch_errors(connection)
        end
        raise e
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