# Franwell Metrc Ruby Client

## Usage

```ruby
Metrc.configure do |config|
  config.api_key = '...'
  config.user_key = '...'
  config.state = :ca
  config.sandbox = [true|false]
end

client = Metrc::Client.new(debug: true)
client.get(:packages, '1A4FF0300000026000000010')
```

```
Metrc API Request debug
client.get('/packages/v1/1A4FF0300000026000000010', {:basic_auth=>{:username=>"...", :password=>"..."}})
########################

Metrc API Response debug
{"Id":4902,"Label":"1A4FF0300000026000000010","PackageType":"Product","SourceHarvestNames":"","RoomId":null,"RoomName":null,"Quantity":2.0000,"UnitOfMeasureName":"Each","UnitOfMeasureAbbreviation":"ea","ProductId":3302,"ProductName":"BK Test Item Kush New","ProductCategoryName":"Capsule/Tablet","PackagedDate":"2018-02-13","InitialLabTestingState":"AwaitingCon[...]
[200 OK]
########################
```

See ```./lib/Metrc/client.rb``` for implemented endpoints.

Metrc (CA) API Docs https://api-ca.metrc.com/Documentation

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
