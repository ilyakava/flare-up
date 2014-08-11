module FlareUp

  class Boot

    # TODO: This control flow is untested
    def self.boot(options)
      conn = create_connection(options)
      copy = create_copy_command(options)

      begin
        handle_load_errors(copy.execute(conn))
      rescue DataSourceError => e
        CLI.output_error("\x1b[31m#{e.message}")
        CLI.bailout(1)
      end

    end

    def self.create_connection(options)
      FlareUp::Connection.new(
        options[:redshift_endpoint],
        options[:database],
        options[:redshift_username],
        options[:redshift_password]
      )
    end

    def self.create_copy_command(options)
      copy = FlareUp::CopyCommand.new(
        options[:table],
        options[:data_source],
        options[:aws_access_key],
        options[:aws_secret_key]
      )
      copy.columns = options[:column_list] if options[:column_list]
      copy.options = options[:copy_options] if options[:copy_options]
      copy
    end

    # TODO: How can we test this?
    def self.handle_load_errors(stl_load_errors)
      return if stl_load_errors.empty?
      puts "\x1b[31mThere was an error processing the COPY command:"
      stl_load_errors.each do |e|
        puts e.pretty_print
      end
    end

  end

end