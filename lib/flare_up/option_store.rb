module FlareUp

  class OptionStore

    def self.store_option(name, value)
      storage[name] = value
    end

    def self.store_options(options)
      storage.merge!(options)
    end

    def self.get(name)
      storage[name]
    end

    def self.clear
      storage.clear
    end

    def self.storage
      @storage ||= {}
    end
    private_class_method :storage

  end

end