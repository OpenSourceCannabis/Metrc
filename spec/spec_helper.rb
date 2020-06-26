require 'yaml'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

if File.exists?('./spec/spec_CA_credentials.yml')
  $spec_credentials = YAML.load_file('./spec/spec_CA_credentials.yml')
else
  $spec_credentials = {
    api_key: 'abc',
    user_key: 'bcd',
    state: :ca,
    license: 'CML00-0000000'
  }
end

require 'webmock/rspec'
require 'Metrc'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.include ConfigurationHelper
end
