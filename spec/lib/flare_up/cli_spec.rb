describe FlareUp::CLI do

  let(:required_arguments) { %w(copy TEST_DATA_SOURCE TEST_REDSHIFT_ENDPOINT TEST_DATABASE TEST_TABLE) }
  let(:required_options) do
    {
      :data_source => 'TEST_DATA_SOURCE',
      :redshift_endpoint => 'TEST_REDSHIFT_ENDPOINT',
      :database => 'TEST_DATABASE',
      :table => 'TEST_TABLE'
    }
  end

  describe '#copy' do

    context 'when no options are specified' do
      it 'should boot with the proper options' do
        expect(FlareUp::Boot).to receive(:boot).with(required_options)
        FlareUp::CLI.start(required_arguments)
      end
    end

    context 'when column ordering is specified' do
      it 'should boot with the proper options' do
        expect(FlareUp::Boot).to receive(:boot).with(required_options.merge(:column_list => %w(c1 c2 c3)))
        FlareUp::CLI.start(required_arguments + %w(--column_list c1 c2 c3))
      end
    end

    context 'when COPY options are specified' do
      it 'should boot with the proper options' do
        expect(FlareUp::Boot).to receive(:boot).with(required_options.merge(:copy_options => 'TEST_COPY_OPTIONS WITH A SPACE'))
        FlareUp::CLI.start(required_arguments + ['--copy_options', 'TEST_COPY_OPTIONS WITH A SPACE'])
      end
    end

    describe 'AWS credentials' do

      describe 'access key' do
        context 'when an AWS access key is specified' do
          it 'should boot with the proper options' do
            expect(FlareUp::Boot).to receive(:boot).with(required_options.merge(:aws_access_key => 'TEST_AWS_ACCESS_KEY'))
            FlareUp::CLI.start(required_arguments + %w(--aws_access_key TEST_AWS_ACCESS_KEY))
          end
        end
        context 'when an AWS access key is not specified' do
          context 'when the key is available via ENV' do
            it 'should boot with the key from the environment'
          end
          context 'when the key is not available via ENV' do
            it 'should be an error'
          end
        end
      end

      describe 'secret key' do
        context 'when an AWS secret key is specified' do
          it 'should boot with the proper options' do
            expect(FlareUp::Boot).to receive(:boot).with(required_options.merge(:aws_secret_key => 'TEST_AWS_SECRET_KEY'))
            FlareUp::CLI.start(required_arguments + %w(--aws_secret_key TEST_AWS_SECRET_KEY))
          end
        end
        context 'when an AWS secret key is not specified' do
          context 'when the key is available via ENV' do
            it 'should boot with the key from the environment'
          end
          context 'when the key is not available via ENV' do
            it 'should be an error'
          end
        end
      end

    end

  end

end