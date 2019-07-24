require 'yaml'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$spec_credentials = YAML.load_file('./spec/spec_CA_credentials.yml')

require 'webmock/rspec'
require 'Metrc'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.include ConfigurationHelper
end
