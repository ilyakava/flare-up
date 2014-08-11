module FlareUp

  class Boot

    # TODO: This control flow is untested
    def self.boot(options)
      conn = create_connection(options)
      copy = create_copy_command(options)

      errors = copy.execute(conn)
      if errors.empty?
        return
      end

      errors.each do |e|
        puts e.pretty_print
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

  end

end