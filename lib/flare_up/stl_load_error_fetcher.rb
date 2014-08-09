module FlareUp

  class STLLoadErrorFetcher

    def self.fetch_errors(connection)
      query_result = connection.execute('SELECT * FROM stl_load_errors ORDER BY query DESC, line_number, position LIMIT 10')
      errors = []
      query_result.each do |row|
        errors << STLLoadError.from_pg_results_row(row)
      end
      errors
    end

  end

end