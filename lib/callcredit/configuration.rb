require 'faraday'
require 'callcredit/version'

module Callcredit
  module Configuration
    DEFAULT_OPTIONS = {
      adapter:              Faraday.default_adapter,
      company:              nil,
      username:             nil,
      password:             nil,
      application_name:     nil,
      api_endpoint:         "https://ct.callcreditsecure.co.uk/callvalidateapi/incomingserver.php",
      user_agent:           "Callcredit Ruby Gem #{Callcredit::VERSION}".freeze
    }.freeze

    VALID_OPTIONS_KEYS = DEFAULT_OPTIONS.keys

    attr_accessor *VALID_OPTIONS_KEYS

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      Hash[VALID_OPTIONS_KEYS.map {|key| [key, send(key)] }]
    end

    # When this module is extended, set all configuration options to their
    # default values
    def self.extended(base)
      base.reset
    end

    # Reset all configuration options to defaults
    def reset
      DEFAULT_OPTIONS.map do |key, value|
        self.send("#{key}=", value)
      end
    self
    end
  end
end