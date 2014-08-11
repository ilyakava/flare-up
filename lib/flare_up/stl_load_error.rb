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

    def ==(other_error)
      return false unless @err_reason == other_error.err_reason
      return false unless @raw_field_value == other_error.raw_field_value
      return false unless @raw_line == other_error.raw_line
      return false unless @col_length == other_error.col_length
      return false unless @type == other_error.type
      return false unless @colname == other_error.colname
      return false unless @filename == other_error.filename
      return false unless @position == other_error.position
      return false unless @line_number == other_error.line_number
      true
    end

    def pretty_print
      output = ''
      output += "REASON: #{@err_reason}\n"
      output += "LINE  : #{@line_number}\n"
      output += "POS   : #{@position}\n"
      output += "COLUMN: #{@colname} (LENGTH=#{@col_length})\n" if @colname.length > 0 && @col_length > 0
      output += "TYPE  : #{@type}\n" if @type.length > 0
      output += "LINE  : #{@raw_line}\n"
      output += "        #{' ' * @position}^"
    end

    def self.from_pg_results_row(row)
      STLLoadError.new(
        row['err_reason'].strip,
        row['raw_field_value'].strip,
        row['raw_line'].strip,
        row['col_length'].strip.to_i,
        row['type'].strip,
        row['colname'].strip,
        row['filename'].strip,
        row['position'].strip.to_i,
        row['line_number'].strip.to_i
      )
    end

  end

end