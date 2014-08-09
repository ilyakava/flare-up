module FlareUp

  class Connection

    attr_accessor :host
    attr_accessor :port
    attr_accessor :dbname
    attr_accessor :user
    attr_accessor :password
    attr_accessor :connect_timeout

    def connect
      PG.connect(connection_parameters)
    end

    def connection_parameters
      {
        :host => @host,
        :dbname => @dbname,
        :user => @user,
        :password => @password,
        :port => @port,
        :connect_timeout => @connect_timeout
      }
    end

  end

end