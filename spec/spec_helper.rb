require 'flare_up'
require 'rspec/its'

ENV['TESTING'] = 'TESTING'

RSpec.configure do |config|

  config.before(:each) do
    FlareUp::OptionStore.clear
  end

end
