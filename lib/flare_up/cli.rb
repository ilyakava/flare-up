module FlareUp

  class CLI < Thor

    desc 'copy DATA_SOURCE REDSHIFT_ENDPOINT DATABASE TABLE', 'COPY data into REDSHIFT_ENDPOINT from DATA_SOURCE into DATABASE.TABLE'
    long_desc = <<-LONGDESC
    `flare-up copy` executes the Redshift COPY command, loading data from
    DATA_SOURCE into DATABASE_NAME.TABLE_NAME at REDSHIFT_ENDPOINT.

    TODO Examples:
    > $ flare-up copy
    LONGDESC

    option :column_list, :type => :array
    option :copy_options, :type => :string, :desc => "Appended to the end of the COPY command; enclose \"IN QUOTES\""
    option :aws_access_key, :type => :string, :desc => "Required unless ENV['AWS_ACCESS_KEY_ID'] is set."
    option :aws_secret_key, :type => :string, :desc => "Required unless ENV['AWS_SECRET_ACCESS_KEY'] is set."

    def copy(data_source, endpoint, database_name, table_name)
      boot_options = {
        :data_source => data_source,
        :redshift_endpoint => endpoint,
        :database => database_name,
        :table => table_name
      }
      options.each { |k, v| boot_options[k.to_sym] = v }
      Boot.boot(boot_options)
    end

  end

end