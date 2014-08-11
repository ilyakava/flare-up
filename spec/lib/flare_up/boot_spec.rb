describe FlareUp::Boot do


  describe '.boot' do
    let(:copy_command) { instance_double('FlareUp::CopyCommand') }

    context 'when there is an error' do
      before do
        expect(FlareUp::Boot).to receive(:create_copy_command).and_return(copy_command)
        expect(copy_command).to receive(:execute).and_raise(FlareUp::DataSourceError)
      end
      it 'should handle the error' do
        expect(FlareUp::CLI).to receive(:bailout).with(1)
        expect {
          FlareUp::Boot.boot({})
        }.not_to raise_error
      end
    end

  end

  describe '.create_connection' do
    let(:options) {
      {
        :redshift_endpoint => 'TEST_REDSHIFT_ENDPOINT',
        :database => 'TEST_DATABASE',
        :redshift_username => 'TEST_REDSHIFT_USERNAME',
        :redshift_password => 'TEST_REDSHIFT_PASSWORD'
      }
    }

    it 'should create a connection' do
      connection = FlareUp::Boot.create_connection(options)
      expect(connection.host).to eq('TEST_REDSHIFT_ENDPOINT')
      expect(connection.dbname).to eq('TEST_DATABASE')
      expect(connection.user).to eq('TEST_REDSHIFT_USERNAME')
      expect(connection.password).to eq('TEST_REDSHIFT_PASSWORD')
    end
  end

  describe '.create_copy_command' do

    let(:options) {
      {
        :table => 'TEST_TABLE',
        :data_source => 'TEST_DATA_SOURCE',
        :aws_access_key => 'TEST_ACCESS_KEY',
        :aws_secret_key => 'TEST_SECRET_KEY'
      }
    }

    it 'should create a proper copy command' do
      command = FlareUp::Boot.create_copy_command(options)
      expect(command.table_name).to eq('TEST_TABLE')
      expect(command.data_source).to eq('TEST_DATA_SOURCE')
      expect(command.aws_access_key_id).to eq('TEST_ACCESS_KEY')
      expect(command.aws_secret_access_key).to eq('TEST_SECRET_KEY')
    end

    context 'when columns are specified' do
      before do
        options.merge!(:column_list => ['c1'])
      end
      it 'should create a proper copy command' do
        command = FlareUp::Boot.create_copy_command(options)
        expect(command.columns).to eq(['c1'])
      end
    end

    context 'when options are specified' do
      before do
        options.merge!(:copy_options => '_')
      end
      it 'should create a proper copy command' do
        command = FlareUp::Boot.create_copy_command(options)
        expect(command.options).to eq('_')
      end
    end

  end

end