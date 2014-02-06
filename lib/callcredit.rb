require 'callcredit/configuration'
require 'callcredit/constants'
require 'callcredit/client'
require 'callcredit/util'

# Errors
require 'callcredit/errors/callcredit_error'
require 'callcredit/errors/api_error'

module Callcredit
  extend Configuration
  extend Constants

  class << self
    # Alias for Callcredit::Client.new
    def client(options={})
      Callcredit::Client.new(options)
    end

    # Delegate to Callcredit::Client
    def method_missing(method, *args, &block)
      return super unless client.respond_to?(method)
      client.send(method, *args, &block)
    end

    def respond_to?(method)
      client.respond_to?(method) || super
    end
  end
end
