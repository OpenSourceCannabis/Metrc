module ConfigurationHelper
  def configure_client
    Metrc.configure do |config|
      config.api_key  = $spec_credentials['api_key']
      config.user_key = $spec_credentials['user_key']
      config.sandbox  = $spec_credentials['sandbox']
      config.state    = $spec_credentials['state']
    end
  end
end
