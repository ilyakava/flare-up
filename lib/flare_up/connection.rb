module FlareUp

  class ConnectionError < StandardError
  end
  class HostUnknownOrInaccessibleError < ConnectionError
  end
  class TimeoutError < ConnectionError
  end
  class NoDatabaseError < ConnectionError
  end
  class AuthenticationError < ConnectionError
  end
  class UnknownError < ConnectionError
  end

  class Connection

    attr_accessor :host
    attr_accessor :port
    attr_accessor :dbname
    attr_accessor :user
    attr_accessor :password
    attr_accessor :connect_timeout

    def initialize(host, dbname, user, password)
      @host = host
      @dbname = dbname
      @user = user
      @password = password

      @port = 5439
      @connect_timeout = 5
    end

    # TODO - Not quite sure how to test this; perhaps fold connect/execute into
    # TODO   one method so we can close connections in case of failure, etc.
    def execute(statement)
      @pg_conn ||= connect
      @pg_conn.exec(statement)
    end

    private

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
            raise NoDatabaseError, "Database #{@dbname} does not exist"
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