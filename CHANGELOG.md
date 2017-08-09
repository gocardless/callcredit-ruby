## 1.0.0 - August 9, 2017

- Drop support for Ruby 2.0.x and 2.1.x, which have both reached end-of-life
- Allow versions of `faraday_middleware` up to v0.12.x

## 0.4.0 - December 31, 2014

- Add support for BankStandard and BankEnhanced checks
- Tweak `Callcredit::Response#result` to support multiple kinds of check (i.e. not just
identity checks)
- Enforce code style with Rubocop

## 0.3.8 - July 16, 2014

- Include request ID (RID) on all requests

## 0.3.7 - June 3, 2014

- Add support for Faraday 0.9

## 0.3.6 - April 22, 2014

- Catch Faraday errors without a response

## 0.3.5 - February 24, 2014

- Remove insistence on inclusion of date_of_birth, postcode and names

## 0.3.4 - February 24, 2014

- Validate input (including converting non-ASCII characters in names)

## 0.3.3 - February 19, 2014

- Handle errors from Callcredit that aren't name-spaced to a module

## 0.3.2 - February 11, 2014

- Allow a title to be passed as personal data. Specify "Unknown" if not
present

## 0.3.1 - February 11, 2014

- Specify dependency versions

## 0.3.0 - February 10, 2014

- Wrap responses in a Response object. Make config accessible from the client

## 0.2.1 - February 9, 2014

- Support Date, Time, and Datetime instances for `date_of_birth` param

## 0.2.0 - February 7, 2014

- Major refactor to make setup and use more explicit
- Moved error checking to middleware
- Fixed error handling for multiple errors

## 0.1.1 - February 6, 2014

- Added `id_enhanced_check` method to `Client`

## 0.1.0 - February 6, 2014

- Implemented `check` method on `Request` module to allow ID checks
- Added readme

## 0.0.1 - February 5, 2014

- Initial commit
