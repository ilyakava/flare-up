describe FlareUp::Connection do

  subject do
    FlareUp::Connection.new.tap do |c|
      c.host = 'TEST_HOST'
      c.port = 111
      c.dbname = 'TEST_DB_NAME'
      c.user = 'TEST_USER'
      c.password = 'TEST_PASSWORD'
      c.connect_timeout = 222
    end
  end

  its(:host) { should == 'TEST_HOST' }
  its(:port) { should == 111 }
  its(:dbname) { should == 'TEST_DB_NAME' }
  its(:user) { should == 'TEST_USER' }
  its(:password) { should == 'TEST_PASSWORD' }
  its(:connect_timeout) { should == 222 }

  describe '#connect' do

    let(:mock_params) { { :foo => 'bar' } }

    before do
      allow(subject).to receive(:connection_parameters).and_return(mock_params)
    end

    it 'should connect to Redshift with the appropriate parameters' do
      expect(PG).to receive(:connect).with(mock_params)

      subject.connect
    end

  end

  describe '#connection_parameters' do

    it 'should return the required parameters' do
      expect(subject.connection_parameters).to eq({
        :host => 'TEST_HOST',
        :port => 111,
        :dbname => 'TEST_DB_NAME',
        :user => 'TEST_USER',
        :password => 'TEST_PASSWORD',
        :connect_timeout => 222,
      })
    end

  end

end