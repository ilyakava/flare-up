describe FlareUp::CLI do

  describe '.start' do
    it 'should exist so the CLI can boot' do
      expect(FlareUp::CLI).to respond_to(:start)
    end
  end

end