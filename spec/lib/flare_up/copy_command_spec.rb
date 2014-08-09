describe FlareUp::CopyCommand do

  subject do
    FlareUp::CopyCommand.new('TEST_TABLE_NAME', 'TEST_DATA_SOURCE', 'TEST_ACCESS_KEY', 'TEST_SECRET_KEY')
  end

  its(:table_name) { should == 'TEST_TABLE_NAME' }
  its(:data_source) { should == 'TEST_DATA_SOURCE' }
  its(:aws_access_key_id) { should == 'TEST_ACCESS_KEY' }
  its(:aws_secret_access_key) { should == 'TEST_SECRET_KEY' }
  its(:columns) { should == [] }

  describe '#get_command' do
    context 'when no optional fields are provided' do
      it 'should return a basic COPY command' do
        expect(subject.get_command).to eq("COPY TEST_TABLE_NAME  FROM 'TEST_DATA_SOURCE' CREDENTIALS 'aws_access_key_id=TEST_ACCESS_KEY;aws_secret_access_key=TEST_SECRET_KEY'")
      end
    end

    context 'when column names are provided' do
      before do
        subject.columns = %w(column_name1 column_name2)
      end
      it 'should include the column names in the command' do
        expect(subject.get_command).to start_with('COPY TEST_TABLE_NAME (column_name1, column_name2) FROM')
      end
    end
  end

  describe '#columns=' do
    context 'when an array' do
      it 'should assign the property' do
        subject.columns = %w(column_name1 column_name2)
        expect(subject.columns).to eq(%w(column_name1 column_name2))
      end
    end

    context 'when not an array' do
      it 'should not assign the property and be an error' do
        subject.columns = %w(column_name1)
        expect {
          subject.columns = '_'
        }.to raise_error(ArgumentError)
        expect(subject.columns).to eq(%w(column_name1))
      end
    end
  end

end