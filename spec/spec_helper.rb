require 'active_record'
require 'logger'
require 'unscoped_associations'

ActiveRecord::Base.logger = Logger.new(STDOUT)

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.mock_with :rspec
  config.order = 'random'
end
