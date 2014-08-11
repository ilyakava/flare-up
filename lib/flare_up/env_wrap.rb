module FlareUp

  class ENVWrap

    def self.get(variable)
      ENV[variable]
    end

  end

end