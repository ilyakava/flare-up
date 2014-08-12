describe FlareUp::Emitter do

  describe '.sanitize' do

    context 'when colorize output is disabled' do
      before do
        FlareUp::Emitter.store_options({:colorize_output => false})
      end
      it 'should remove color codes' do
        expect(FlareUp::Emitter.sanitize("\x1b[31mHello, World")).to eq('Hello, World')
      end
    end

    context 'when a risky option is being output' do
      before do
        FlareUp::Emitter.store_options({:aws_access_key => 'foo'})
      end
      it 'should hide it' do
        expect(FlareUp::Emitter.sanitize('Hellofoo')).to eq('HelloREDACTED')
      end
    end

  end

end