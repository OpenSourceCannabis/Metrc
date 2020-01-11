# Franwell Metrc Ruby Client

## Usage

```ruby
require 'Metrc'

Metrc.configure do |config|
  config.api_key        = credentials['api_key'] # vendor/integrator key (assigned by Metrc)
  config.user_key       = credentials['user_key'] # programmatic access API key (user generated)
  config.license_number = credentials['license_number'] # license number 
  config.base_uri       = credentials['base_uri'] # base URI of the API 
  config.state          = credentials['state']
end
client = Metrc::Client.new(debug: true)

# alternatively
client = Metrc::Client.init(credentials)

client.retrive('1A4FF0300000026000000010') # gets a specific package

client.inbox # lists incoming transfers

results = [
  { 
    LabTestTypeName: 'Terpenoids (mg/g) (Flower) [Phase 3]',
    Quantity: 23.17,
    Passed: true,
    Notes: 'LabFlow CannabisLIMS'
  }
]

client.create_results('1A4FF0100000027000003415', results) # POST laboratory results
```

See ```./lib/Metrc/client.rb``` for implemented endpoints.

Metrc (CA) API Docs https://api-ca.metrc.com/Documentation
LabFlow Cannabis LIMS https://CannabisLIMS.com

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
