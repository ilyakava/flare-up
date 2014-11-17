describe FlareUp::Command::DropTable do

  subject do
    FlareUp::Command::DropTable.new('TEST_TABLE_NAME', nil, nil, nil)
  end

  its(:table_name) { should == 'TEST_TABLE_NAME' }

  describe '#get_command' do
    context 'when no optional fields are provided' do
      it 'should return a basic DROP TABLE command' do
        expect(subject.get_command).to eq("DROP TABLE TEST_TABLE_NAME ")
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
            expect { subject.execute(conn) }.to raise_error(FlareUp::SyntaxError, 'Syntax error in the DROP TABLE command: [at or near "lmlkmlk3"].')
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
