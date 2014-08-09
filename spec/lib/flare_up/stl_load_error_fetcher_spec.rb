describe FlareUp::STLLoadErrorFetcher do

  describe '.fetch_errors' do

    let(:connection) { instance_double('FlareUp::Connection') }

    before do
      expect(connection).to receive(:execute).
        with('SELECT * FROM stl_load_errors ORDER BY query DESC, line_number, position LIMIT 10').
        and_return([
        {
          'err_reason' => 'TEST_REASON',
          'raw_field_value' => 'TEST_RAW_FIELD_VALUE',
          'raw_line' => 'TEST_RAW_LINE',
          'col_length' => '1',
          'type' => 'TEST_TYPE',
          'colname' => 'TEST_COLNAME',
          'filename' => 'TEST_FILENAME',
          'position' => '2',
          'line_number' => '3'
        }
      ])
    end

    it 'should return the load errors' do
      expect(FlareUp::STLLoadErrorFetcher.fetch_errors(connection)).to eq(
        [
          FlareUp::STLLoadError.new(
            'TEST_REASON',
            'TEST_RAW_FIELD_VALUE',
            'TEST_RAW_LINE',
            1,
            'TEST_TYPE',
            'TEST_COLNAME',
            'TEST_FILENAME',
            2,
            3
          )
        ]
      )
    end

  end

end