# rubocop:disable Naming/FileName,Lint/MissingCopEnableDirective
require 'spec_helper'

describe Metrc do
  before(:each) { configure_client }

  it 'has a version number' do
    expect(Metrc::VERSION).not_to be nil
  end

  it 'accepts a configuration, requires a complete configuration' do
    Metrc.configure do |config|
      config.state = nil
    end

    expect(Metrc.configuration.api_key).not_to be_nil
    expect(Metrc.configuration.user_key).not_to be_nil
    expect(Metrc.configuration.incomplete?).not_to be_nil
  end

  it 'does not initialize without credentials' do
    Metrc.configure do |config|
      config.state = nil
    end

    expect { Metrc::Client.new }
      .to(raise_error(Metrc::Errors::MissingConfiguration))
  end

  it 'builds a sandbox base URI' do
    Metrc.configure do |config|
      config.sandbox = true
      config.state   = :ca
    end

    client = Metrc::Client.new

    expect(client.uri).to eq('https://sandbox-api-ca.metrc.com')
  end

  it 'builds a production base URI' do
    Metrc.configure do |config|
      config.state = :ca
    end

    client = Metrc::Client.new

    expect(client.uri).to eq('https://api-ca.metrc.com')
  end
end
