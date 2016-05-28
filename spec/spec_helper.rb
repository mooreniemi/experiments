$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'pry'

# give us some debug info when running rspec
ENV['TEST_ENV'] = 'true'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # empty because global RSpec is filled for me most of the time
end
