describe FlareUp::Command::CreateTable do

  subject do
    FlareUp::Command::CreateTable.new('TEST_TABLE_NAME', nil, nil, nil)
  end

  its(:table_name) { should == 'TEST_TABLE_NAME' }
  its(:columns) { should == [] }

  describe '#get_command' do
    context 'when no optional fields are provided' do
      it 'should return a basic CREATE TABLE command' do
        expect(subject.get_command).to eq("CREATE TABLE TEST_TABLE_NAME  ")
      end
    end

    context 'when column names are provided' do
      before do
        subject.columns = 'column_name1 char(24) column_name2 varchar(2000)'
      end
      it 'should include the column names in the command' do
        expect(subject.get_command).to start_with('CREATE TABLE TEST_TABLE_NAME (column_name1 char(24), column_name2 varchar(2000))')
      end
    end
  end

  describe '#columns=' do
    context 'when a string' do
      it 'should assign the property' do
        subject.columns = 'column_name1 char(24) column_name2 varchar(2000)'
        expect(subject.columns).to eq(['column_name1', 'char(24)', 'column_name2', 'varchar(2000)'])
      end
      it 'should assign an empty array for an empty string' do
        subject.columns = ''
        expect(subject.columns).to eq([])
      end
    end

    context 'when not a string' do
      it 'should not assign the property and be an error' do
        subject.columns = 'column_name1 char(24)'
        expect {
          subject.columns = ['column_name_in_arr char(24)']
        }.to raise_error(ArgumentError)
        expect(subject.columns).to eq(['column_name1', 'char(24)'])
      end
    end

    context 'when not a string of name, type pairs' do
      it 'should not assign the property and be an error' do
        subject.columns = 'column_name1 char(24)'
        expect {
          subject.columns = 'column_name1'
        }.to raise_error(ArgumentError)
        expect(subject.columns).to eq(['column_name1', 'char(24)'])
      end
    end
  end

  describe '#execute' do

    let(:conn) { instance_double('FlareUp::Connection') }

    context 'when successful' do
      before do
        expect(conn).to receive(:execute)
      end
      it 'should do something' do
        expect(subject.execute(conn)).to eq([])
      end
    end

    context 'when unsuccessful' do

      before do
        expect(conn).to receive(:execute).and_raise(exception, message)
      end

      context 'when there was an internal error' do

        let(:exception) { PG::InternalError }

        context 'when there was an error loading' do
          let(:message) { "Check 'stl_load_errors' system table for details" }
          before do
            allow(FlareUp::STLLoadErrorFetcher).to receive(:fetch_errors).and_return('FOO')
          end
          it 'should respond with a list of errors' do
            expect(subject.execute(conn)).to eq('FOO')
          end
        end

        context 'when there was another kind of internal error' do
          let(:message) { '_' }
          it 'should respond with a list of errors' do
            expect { subject.execute(conn) }.to raise_error(PG::InternalError, '_')
          end
        end

        context 'when there is a syntax error in the command' do
          let(:message) { 'ERROR:  syntax error at or near "lmlkmlk3" (PG::SyntaxError)' }
          it 'should be error' do
            expect { subject.execute(conn) }.to raise_error(FlareUp::SyntaxError, 'Syntax error in the CREATE TABLE command: [at or near "lmlkmlk3"].')
          end
        end
      end

      context 'when there was another type of error' do
        let(:exception) { PG::ConnectionBad }
        let(:message) { '_' }
        it 'should do something' do
          expect { subject.execute(conn) }.to raise_error(PG::ConnectionBad, '_')
        end
      end
    end
  end
end
