# Callcredit Ruby Client Library

Simple Ruby Gem for interacting with Callcredit's CallValidate API. Wraps the
XML submissions and responses required so you can deal with Ruby hashes
instead.

[![Gem Version](https://badge.fury.io/rb/callcredit.svg)](http://badge.fury.io/rb/callcredit)
[![Build Status](https://travis-ci.org/gocardless/callcredit-ruby.svg?branch=master)](https://travis-ci.org/gocardless/callcredit-ruby)

## Usage

### Installation

You don't need this source code unless you want to modify the gem. 

If you just want to use it, you should just add it to your `Gemfile`:

```ruby
gem 'callcredit', '~> 1.0.0'
````

### Initialising the gem

Requires your Callcredit credentials. If you don't have any, you'll need to
call the sales team at [Callcredit](http://callcredit.co.uk).

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

#### BankStandard check

To perform a BankStandard check use:

```ruby
Callcredit.bank_standard_check(account_number: "44779911", sort_code: "200000")
```

The library will raise an error unless you provide both account_number and sort_code.

#### BankEnhanced check

To perform a BankEnhanced check use:

```ruby
Callcredit.bank_enhanced_check(first_name: "Tim", last_name: "Rogers", postcode: "EC1V 7LQ", account_number: "44779911", sort_code: "200000", building_number: "338-346")
```

The library will raise an error if you're missing any of the required
parameters (first_name, last_name, building_number, postcode, account_number
and sort_code).

#### Other checks

For any other check, simply pass the name of the check you'd like to perform
into the `perform_check` method, along with details of the individual you're
checking.

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

### Parsing responses

Unless you've set the "raw" argument to true in your config, checks called by
name return a `Response` object and checks called using the generic
`perform_check` method return a hash.

```ruby
Callcredit.id_enhanced_check(...)              # => Callcredit::Response

Callcredit.id_enhanced_check(...).input        # => Hash of input params, as
                                               #    returned by Callcredit

Callcredit.id_enhanced_check(...).result       # => Hash of results, mapping
                                               #    a check type to its results

Callcredit.id_enhanced_check(...).full_result  # => Hash of the full XML body
                                               #    returned by Callcredit

Callcredit.perform_check(...)                  # => Hash of the full XML body
                                               #    returned by Callcredit
```

Set the "raw" argument to true if you need the full, unprocessed response
(including headers, etc.).

```ruby
Callcredit.config[:raw] = true

Callcredit.id_enhanced_check(...)              # => Faraday::Response object
```

---

GoCardless ♥ open source. If you do too, come [join us](https://gocardless.com/about/jobs).
