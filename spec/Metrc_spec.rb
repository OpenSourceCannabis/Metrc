require 'spec_helper'

describe Metrc do
  before(:each) { configure_client }

  it 'has a version number' do
    expect(Metrc::VERSION).not_to be nil
  end

  it 'accepts a configuration, requires a complete configuration' do
    Metrc.configure do |config|
      config.base_uri = nil
      config.state  = nil
    end

    expect(Metrc.configuration.api_key).to eq($spec_credentials['api_key'])
    expect(Metrc.configuration.user_key).to eq($spec_credentials['user_key'])
    expect(Metrc.configuration.incomplete?).to be_truthy
  end

  it 'does not initialize without credentials' do
    Metrc.configure do |config|
      config.base_uri = nil
      config.state = nil
    end

    expect { Metrc::Client.new }
      .to(raise_error(Metrc::Errors::MissingConfiguration))
  end

  it 'initializes with credentials' do

    expect { Metrc::Client.new }
      .not_to raise_error
  end

  # it 'communicates with the API to get users' do
  # end
  #
  # it 'communicates with the API to get inventory' do
  # end
end
