module FlareUp

  class Boot

    # TODO: This control flow is untested
    def self.boot(options)
      conn = create_connection(options)
      copy = create_copy_command(options)

      begin
        Emitter.info("Executing command: #{copy.get_command}")
        handle_load_errors(copy.execute(conn))
      rescue ConnectionError => e
        Emitter.error(e.message)
        CLI.bailout(1)
      rescue CopyCommandError => e
        Emitter.error(e.message)
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
      Emitter.error("There was an error processing the COPY command.  Displaying the last (#{stl_load_errors.length}) errors.")
      stl_load_errors.each do |e|
        Emitter.error(e.pretty_print)
      end
      CLI.bailout(1)
    end

  end

end