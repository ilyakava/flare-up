describe FlareUp::STLLoadError do

  subject do
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
  end

  its(:err_reason) { should == 'TEST_REASON' }
  its(:raw_field_value) { should == 'TEST_RAW_FIELD_VALUE' }
  its(:raw_line) { should == 'TEST_RAW_LINE' }
  its(:col_length) { should == 1 }
  its(:type) { should == 'TEST_TYPE' }
  its(:colname) { should == 'TEST_COLNAME' }
  its(:filename) { should == 'TEST_FILENAME' }
  its(:position) { should == 2 }
  its(:line_number) { should == 3 }

  describe '.from_pg_results_row' do
    let(:values) do
      {
        'err_reason' => 'TEST_REASON',
        'raw_field_value' => 'TEST_RAW_FIELD_VALUE',
        'raw_line' => 'TEST_RAW_LINE',
        'col_length' => 1,
        'type' => 'TEST_TYPE',
        'colname' => 'TEST_COLNAME',
        'filename' => 'TEST_FILENAME',
        'position' => 2,
        'line_number' => 3
      }
    end

    let(:load_error_from_hash) { FlareUp::STLLoadError.from_pg_results_row(values) }

    it 'should be an STLLoadError' do
      expect(load_error_from_hash).to be_a(FlareUp::STLLoadError)
    end

    it 'should store the values properly' do
      expect(load_error_from_hash.err_reason).to eq('TEST_REASON')
      expect(load_error_from_hash.raw_field_value).to eq('TEST_RAW_FIELD_VALUE')
      expect(load_error_from_hash.raw_line).to eq('TEST_RAW_LINE')
      expect(load_error_from_hash.col_length).to eq(1)
      expect(load_error_from_hash.type).to eq('TEST_TYPE')
      expect(load_error_from_hash.colname).to eq('TEST_COLNAME')
      expect(load_error_from_hash.filename).to eq('TEST_FILENAME')
      expect(load_error_from_hash.position).to eq(2)
      expect(load_error_from_hash.line_number).to eq(3)
    end
  end

end