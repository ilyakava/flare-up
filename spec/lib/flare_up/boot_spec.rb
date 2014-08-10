describe FlareUp::Boot do

  describe '.boot' do
    it 'should exist so we can boot the app' do
      expect(FlareUp::Boot).to respond_to(:boot)
    end
  end

end