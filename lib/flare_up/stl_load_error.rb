module FlareUp

  class STLLoadError

    attr_reader :err_reason
    attr_reader :raw_field_value
    attr_reader :raw_line
    attr_reader :col_length
    attr_reader :type
    attr_reader :colname
    attr_reader :filename
    attr_reader :position
    attr_reader :line_number

    def initialize(err_reason, raw_field_value, raw_line, col_length, type, colname, filename, position, line_number)
      @err_reason = err_reason
      @raw_field_value = raw_field_value
      @raw_line = raw_line
      @col_length = col_length
      @type = type
      @colname = colname
      @filename = filename
      @position = position
      @line_number = line_number
    end

    def self.from_pg_results_row(row)
      STLLoadError.new(
        row['err_reason'],
        row['raw_field_value'],
        row['raw_line'],
        row['col_length'],
        row['type'],
        row['colname'],
        row['filename'],
        row['position'],
        row['line_number']
      )
    end

  end

end