$:.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'rrod'
require 'rrod/test_server/rspec'

RSpec.configure do |config|
  config.order                                           = 'random'
  config.run_all_when_everything_filtered                = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus
end

Rrod::TestServer::RSpec.enable!
