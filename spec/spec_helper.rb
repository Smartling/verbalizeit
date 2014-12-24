require 'vcr'
require 'webmock/rspec'
require 'pry'
require 'verbalizeit'
require 'dotenv'
Dotenv.load

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('<API KEY>') { ENV['STAGING_API_KEY'] }
end