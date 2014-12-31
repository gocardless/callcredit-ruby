module Callcredit
  class Config
    DEFAULT_OPTIONS = {
      adapter:          Faraday.default_adapter,
      company:          nil,
      username:         nil,
      password:         nil,
      application_name: nil,
      raw:              false,
      api_endpoint:     "https://ct.callcreditsecure.co.uk/callvalidateapi/" \
                          "incomingserver.php",
      user_agent:       "Callcredit Ruby Gem #{Callcredit::VERSION}".freeze
    }.freeze

    def initialize
      @config = {}
      yield self if block_given?
    end

    def [](name)
      @config.fetch(name, DEFAULT_OPTIONS[name])
    end

    def []=(name, val)
      @config[name] = val
    end

    def clone
      Config.new { |config| @config.each { |k, v| config[k] = v } }
    end
  end
end
