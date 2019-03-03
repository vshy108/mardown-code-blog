ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative '../lib/blog_render'
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/pride'

# Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  Devise::Test::ControllerHelpers
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  require 'rails-controller-testing'
  Rails::Controller::Testing.install
end

# Custom assert function to compare multiple differences
# assert_changes '[Foo.count, Bar.count, Baz.count]', to: [2, 0, 3] do
#   # Do the test changes here.
# end

# # https://github.com/carrierwaveuploader/carrierwave/wiki/Using-CarrierWave-with-Minitest-and-Rails-5
# require 'fileutils'

# # Carrierwave setup and teardown
# carrierwave_template = Rails.root.join('test', 'fixtures', 'files')
# carrierwave_root = Rails.root.join('test', 'support', 'carrierwave')

# # Carrierwave configuration is set here instead of in initializer
# CarrierWave.configure do |config|
#   config.root = carrierwave_root
#   # switch off processing in your tests
#   config.enable_processing = false
#   config.storage = :file
#   config.cache_dir = Rails.root.join('test', 'support', 'carrierwave', 'carrierwave_cache')
# end

# # And copy carrierwave template in
# # puts "Copying\n  #{carrierwave_template.join('uploads').to_s} to\n  #{carrierwave_root.to_s}"
# # mkdir test/fixtures/files/uploads
# # mkdir -p test/support/carrierwave
# FileUtils.cp_r carrierwave_template.join('uploads'), carrierwave_root

# at_exit do
#   # puts "Removing carrierwave test directories:"
#   Dir.glob(carrierwave_root.join('*')).each do |dir|
#     # puts "   #{dir}"
#     FileUtils.remove_entry(dir)
#   end
# end
