require 'time'

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
    attr_reader :start_time

    def initialize(err_reason, raw_field_value, raw_line, col_length, type, colname, filename, position, line_number, start_time)
      @err_reason = err_reason
      @raw_field_value = raw_field_value
      @raw_line = raw_line
      @col_length = col_length
      @type = type
      @colname = colname
      @filename = filename
      @position = position
      @line_number = line_number
      @start_time = start_time
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
      return false unless @start_time == other_error.start_time
      true
    end

    def pretty_print
      output = ''
      output += "\e[33mSTART : \e[37m#{@start_time} (#{@start_time - 7 * 60 * 60} PST)\n"
      output += "\e[33mREASON: \e[37m#{@err_reason}\n"
      output += "\e[33mLINE  : \e[37m#{@line_number}\n"
      output += "\e[33mPOS   : \e[37m#{@position}\n"
      output += "\e[33mCOLUMN: \e[37m#{@colname} (LENGTH=#{@col_length})\n" if @colname.length > 0 && @col_length > 0
      output += "\e[33mTYPE  : \e[37m#{@type}\n" if @type.length > 0
      output += "\e[33mLINE  : \e[37m#{@raw_line}\n"
      output += "              \e[37m#{' ' * @position}^"
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
        row['line_number'].strip.to_i,
        Time.parse("#{row['starttime'].strip} UTC'")
      )
    end

  end

end