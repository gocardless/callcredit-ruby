# Callcredit Ruby Client Library

Simple Ruby Gem for interacting with Callcredit's CallValidate API. Wraps the
XML submissions and responses required so you can deal with Ruby hashes
instead.

## Usage

### Initialising the gem
Requires your Callcredit credentials. If you don't have any, you'll need to
call the sales team at [Callcredit](https://callcredit.co.uk)

```ruby
Callcredit.configure do |config|
  config.company = YOUR_COMPANY_NAME
  config.username = YOUR_USERNAME
  config.password = YOUR_PASSWORD
  config.application_name = YOUR_APPLICATION_NAME
  config.api_endpoint = YOUR_API_ENDPOINT
end
```

### Performing checks
To perform a check, simply pass the name of the check you'd like to perform
into the `check` method, along with details of the individual you're checking.

Currently, this gem only supports checks on the payer's personal information,
but it would be trivial to extend it.

```ruby
data_hash = { personal_data: { first_name: "Grey", last_name: "Baker" } }
Callcredit.check(:id_enhanced, data_hash)
```

By default the body of CallCredit's response is parsed and returned as a hash.
Set the "raw" argument to true if you need the full, unprocessed response
(including headers, etc.).

```ruby
Callcredit.check(:id_enhanced, {}, false)
```