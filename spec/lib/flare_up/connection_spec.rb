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

    context 'when the connection succeeds' do
      let(:mock_params) { { :foo => 'bar' } }

      before do
        allow(subject).to receive(:connection_parameters).and_return(mock_params)
      end

      it 'should connect to Redshift with the appropriate parameters' do
        expect(PG).to receive(:connect).with(mock_params)

        subject.connect
      end
    end

    context 'when the connection does not succeed' do

      before do
        expect(PG).to receive(:connect).and_raise(PG::ConnectionBad, message)
      end

      context 'when the host name is invalid' do
        # PG::ConnectionBad: could not translate host name "redshift.amazonaws.co" to address: nodename nor servname provided, or not known
        let(:message) { 'could not translate host name "TEST_HOSTNAME" to address: nodename nor servname provided, or not known' }
        it 'should be an error' do
          expect { subject.connect }.to raise_error(FlareUp::HostUnknownOrInaccessibleError)
        end
      end

      context 'when the connection times out' do
        # PG::ConnectionBad: timeout expired
        let(:message) { 'timeout expired' }
        it 'should be an error' do
          expect { subject.connect }.to raise_error(FlareUp::TimeoutError)
        end
      end

      context 'when the database does not exist' do
        # PG::ConnectionBad: FATAL:  database "de" does not exist
        let(:message) { 'FATAL:  database "TEST_DB_NAME" does not exist' }
        it 'should be an error' do
          expect { subject.connect }.to raise_error(FlareUp::NoDatabaseError)
        end
      end

      context 'when authenication credentials are invalid' do
        # PG::ConnectionBad: FATAL:  password authentication failed for user "slif1"
        let(:message) { 'password authentication failed for user "slif1"' }
        it 'should be an error' do
          expect { subject.connect }.to raise_error(FlareUp::AuthenticationError)
        end
      end

      context 'when the error is unknown' do
        let(:message) { '_'}
        it 'should be an error' do
          expect { subject.connect }.to raise_error(FlareUp::UnknownError)
        end
      end

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