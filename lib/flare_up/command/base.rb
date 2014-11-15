module FlareUp

  class CommandError < StandardError
  end
  class DataSourceError < CommandError
  end
  class OtherZoneBucketError < CommandError
  end
  class SyntaxError < CommandError
  end

  module Command
    class Base

      attr_reader :table_name

      def initialize(table_name, *args)
        @table_name = table_name
      end
    end
  end
end
