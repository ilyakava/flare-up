describe FlareUp::CLI do

  describe '.class' do
    it 'should be a Thor descendant so it can boot' do
      expect(FlareUp::CLI.new).to be_a(Thor)
    end
  end

end