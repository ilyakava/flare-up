module FlareUp

  class CopyCommand

    attr_reader :table_name
    attr_reader :data_source
    attr_reader :aws_access_key_id
    attr_reader :aws_secret_access_key

    def initialize(table_name, data_source, aws_access_key_id, aws_secret_access_key)
      @table_name = table_name
      @data_source = data_source
      @aws_access_key_id = aws_access_key_id
      @aws_secret_access_key = aws_secret_access_key
    end

    def get_command
      # COPY table_name [ column_list ] FROM data_source CREDENTIALS access_credentials [options]
      "COPY #{@table_name} FROM #{@data_source} CREDENTIALS '#{get_credentials}'"
    end

    private

    def get_credentials
      "aws_access_key_id=#{@aws_access_key_id};aws_secret_access_key=#{@aws_secret_access_key}"
    end

  end

end