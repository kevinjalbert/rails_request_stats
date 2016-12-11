require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rails'
Rails.logger = Logger.new('/dev/null')

require 'rails_request_stats'
