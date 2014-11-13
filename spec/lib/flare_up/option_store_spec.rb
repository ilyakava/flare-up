describe FlareUp::OptionStore do

  describe '.store_option' do
    it 'should store the specified option' do
      FlareUp::OptionStore.store_option('name', 'value')
      expect(FlareUp::OptionStore.get('name')).to eq('value')
    end
  end

  describe '.store_options' do
    it 'should store all the options' do
      FlareUp::OptionStore.store_options(:o1 => 'v1', :o2 => 'v2')
      expect(FlareUp::OptionStore.get(:o1)).to eq('v1')
      expect(FlareUp::OptionStore.get(:o2)).to eq('v2')
    end
  end

  describe '.clear' do
    it 'should remove all options' do
      FlareUp::OptionStore.store_option('name', 'value')
      FlareUp::OptionStore.clear
      expect(FlareUp::OptionStore.get('name')).to eq(nil)
    end
  end

end