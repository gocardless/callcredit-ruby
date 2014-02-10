# Callcredit Ruby Client Library

Simple Ruby Gem for interacting with Callcredit's CallValidate API. Wraps the
XML submissions and responses required so you can deal with Ruby hashes
instead.

## Usage

### Installation

You don't need this source code unless you want to modify the gem. If you just
want to use it, you should run:

```ruby
gem install callcredit
````

### Initialising the gem
Requires your Callcredit credentials. If you don't have any, you'll need to
call the sales team at [Callcredit](https://callcredit.co.uk).

```ruby
Callcredit.configure do |config|
  config[:company]          = YOUR_COMPANY_NAME
  config[:username]         = YOUR_USERNAME
  config[:password]         = YOUR_PASSWORD
  config[:application_name] = YOUR_APPLICATION_NAME
  config[:api_endpoint]     = YOUR_API_ENDPOINT
end
```

### Performing checks

#### Standard AML checks
To perform an IDEnhanced check (the standard AML check) use:

```ruby
Callcredit.id_enhanced_check(first_name: "Grey", last_name: "Baker")
```

The library will raise an error if you're missing any of the required
parameters (first_name, last_name, date_of_birth, building_number and
postcode).

#### Other checks
For any other check, simply pass the name of the check you'd like to perform
into the `perform_check` method, along with details of the individual you're
checking. Note that the gem **won't** validate your inputs for these checks.

```ruby
data_hash = { personal_data: { first_name: "Grey", last_name: "Baker" } }
Callcredit.perform_check(:id_enhanced, data_hash)
```

If you'd like to perform multiple checks at once you can pass an array of
checks.

```ruby
data_hash = { personal_data: { first_name: "Grey", last_name: "Baker" } }
Callcredit.perform_check([:id_enhanced, :credit_score], data_hash)
```

NOTE: Currently, this gem only supports checks on the payer's personal
information (other information won't be passed through to Callsredit).
Extending the gem should be trivial if Callcredit have given you access to
other checks.

### Parsing responses

Unless you've set the "raw" argument to true in your config, checks called by
name return a `Response` object and checks called using the generic
`perform_check` method return a hash.

```ruby
check = Callcredit.id_enhanced_check(...)   # => Callcredit::Response

check.input                                 # => Hash of input params, as
                                            #    returned by Callcredit

check.result                                # => Hash of results

check.full_result                           # => Hash of the full XML body
                                            #    returned by Callcredit

check = Callcredit.perform_check(...)       # => Hash of the full XML body
                                            #    returned by Callcredit
```

Set the "raw" argument to true if you need the full, unprocessed response
(including headers, etc.).

```ruby
Callcredit.config[:raw] = true

check = Callcredit.id_enhanced_check(...)   # => Faraday::Response object
```