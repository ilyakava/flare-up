module FlareUp

  class CLI < Thor

    desc 'copy DATA_SOURCE REDSHIFT_ENDPOINT DATABASE TABLE', 'COPY data into REDSHIFT_ENDPOINT from DATA_SOURCE into DATABASE.TABLE'
    long_desc <<-LONGDESC
`flare-up copy` executes the Redshift COPY command, loading data from\x5
DATA_SOURCE into DATABASE_NAME.TABLE_NAME at REDSHIFT_ENDPOINT.

Documentation for this version can be found at:\x5
https://github.com/sharethrough/flare-up/blob/v#{FlareUp::VERSION}/README.md
    LONGDESC
    option :aws_access_key, :type => :string, :desc => "Required unless ENV['AWS_ACCESS_KEY_ID'] is set."
    option :aws_secret_key, :type => :string, :desc => "Required unless ENV['AWS_SECRET_ACCESS_KEY'] is set."
    option :redshift_username, :type => :string, :desc => "Required unless ENV['REDSHIFT_USERNAME'] is set."
    option :redshift_password, :type => :string, :desc => "Required unless ENV['REDSHIFT_PASSWORD'] is set."
    option :column_list, :type => :array, :desc => 'A space-separated list of columns, should your DATA_SOURCE require it'
    option :copy_options, :type => :string, :desc => "Appended to the end of the COPY command; enclose \"IN QUOTES\""
    option :colorize_output, :type => :boolean, :desc => 'Should Flare-up colorize its output?', :default => true

    def copy(data_source, endpoint, database_name, table_name)
      boot_options = {
        :data_source => data_source,
        :redshift_endpoint => endpoint,
        :database => database_name,
        :table => table_name
      }
      options.each { |k, v| boot_options[k.to_sym] = v }

      begin
        CLI.env_validator(boot_options, :aws_access_key, 'AWS_ACCESS_KEY_ID')
        CLI.env_validator(boot_options, :aws_secret_key, 'AWS_SECRET_ACCESS_KEY')
        CLI.env_validator(boot_options, :redshift_username, 'REDSHIFT_USERNAME')
        CLI.env_validator(boot_options, :redshift_password, 'REDSHIFT_PASSWORD')
      rescue ArgumentError => e
        Emitter.error(e.message)
        CLI.bailout(1)
      end

      OptionStore.store_options(boot_options)

      Boot.boot
    end

    def self.env_validator(options, option_name, env_variable_name)
      options[option_name] ||= ENVWrap.get(env_variable_name)
      return if options[option_name]
      raise ArgumentError, "One of either the --#{option_name} option or the ENV['#{env_variable_name}'] must be set"
    end

    def self.bailout(exit_code)
      exit(exit_code)
    end

  end

end