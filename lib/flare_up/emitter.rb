module FlareUp

  class Emitter

    RISKY_OPTIONS = [
      :aws_access_key,
      :aws_secret_key,
      :redshift_username,
      :redshift_password
    ]

    # TODO: How do we test this?
    def self.error(message)
      $stderr.puts sanitize("\x1b[31m#{message}") unless ENV['TESTING']
    end

    # TODO: How do we test this?
    def self.success(message)
      $stdout.puts sanitize("\x1b[32m#{message}") unless ENV['TESTING']
    end

    # TODO: How do we test this?
    def self.warn(message)
      $stdout.puts sanitize("\x1b[33m#{message}") unless ENV['TESTING']
    end

    # TODO: How do we test this?
    def self.info(message)
      $stdout.puts sanitize(message) unless ENV['TESTING']
    end

    # TODO: How do we test this?
    def self.sanitize(message)
      RISKY_OPTIONS.each do |risky_option|
        message.gsub!(@BOOT_OPTIONS[risky_option], 'REDACTED') if @BOOT_OPTIONS[risky_option]
      end
      message.gsub!(/\e\[(\d+)(;\d+)*m/, '') unless @BOOT_OPTIONS[:colorize_output]
      message
    end

    # TODO: How do we test this?
    def self.store_options(options)
      @BOOT_OPTIONS = options
    end

  end

end