describe FlareUp::CopyCommand do

  subject do
    FlareUp::CopyCommand.new('TEST_TABLE_NAME', 'TEST_DATA_SOURCE', 'TEST_ACCESS_KEY', 'TEST_SECRET_KEY')
  end

  its(:table_name) { should == 'TEST_TABLE_NAME' }
  its(:data_source) { should == 'TEST_DATA_SOURCE' }
  its(:aws_access_key_id) { should == 'TEST_ACCESS_KEY' }
  its(:aws_secret_access_key) { should == 'TEST_SECRET_KEY' }

  describe '#get_command' do
    context 'when no optional fields are provided' do
      it 'should return a basic COPY command' do
        expect(subject.get_command).to eq("COPY TEST_TABLE_NAME FROM 'TEST_DATA_SOURCE' CREDENTIALS 'aws_access_key_id=TEST_ACCESS_KEY;aws_secret_access_key=TEST_SECRET_KEY'")
      end
    end
  end

end