# Franwell Metrc Systems Ruby Client

## Usage

```ruby
Metrc.configure do |config|
  config.api_key = ''
  config.mme_code = ''
  config.base_uri = 'https://watest.leafdatazone.com/api/v1/'
end

client = Metrc::Client.new(debug: true)
client.get_users

> {"total"=>1, "per_page"=>2500, "current_page"=>1, "last_page"=>1, "next_page_url"=>nil, "prev_page_url"=>nil, "from"=>1, "to"=>1, "data"=>[{"id"=>3473, "email"=>"et@pharmware.net", "first_name"=>"Emanuele", "last_name"=>"Tozzato ", "auth_level"=>"admin", "external_id"=>"", "global_id"=>"WASTATE1.US2OH", "global_mme_id"=>nil}]}

```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
