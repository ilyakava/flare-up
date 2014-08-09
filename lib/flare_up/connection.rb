module FlareUp

  class HostUnknownOrInaccessibleError < StandardError
  end
  class TimeoutError < StandardError
  end
  class NoDatabaseError < StandardError
  end
  class AuthenticationError < StandardError
  end
  class UnknownError < StandardError
  end

  class Connection

    attr_accessor :host
    attr_accessor :port
    attr_accessor :dbname
    attr_accessor :user
    attr_accessor :password
    attr_accessor :connect_timeout

    def connect
      begin
        PG.connect(connection_parameters)
      rescue PG::ConnectionBad => e
        case e.message
          when /nodename nor servname provided, or not known/
            raise HostUnknownOrInaccessibleError, "Host unknown or unreachable: #{@host}"
          when /timeout expired/
            raise TimeoutError, 'Timeout connecting to the database (have you checked your Redshift security groups?)'
          when /database ".+" does not exist/
            raise NoDatabaseError, "Database #{@db_name} does not exist"
          when /password authentication failed for user/
            raise AuthenticationError, "Either username '#{@user}' or password invalid"
          else
            raise UnknownError
        end
      end
    end

    def connection_parameters
      {
        :host => @host,
        :port => @port,
        :dbname => @dbname,
        :user => @user,
        :password => @password,
        :connect_timeout => @connect_timeout
      }
    end

  end

end