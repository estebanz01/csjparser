$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'csjparser'
require 'rspec'
require 'coveralls'

# Setup coveralls.
Coveralls.wear!

RSpec.configure do |config|
end
