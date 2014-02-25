require 'faraday_middleware'
require 'nokogiri'

require 'callcredit/version'
require 'callcredit/util'
require 'callcredit/config'
require 'callcredit/request'
require 'callcredit/constants'
require 'callcredit/validations'
require 'callcredit/client'
require 'callcredit/response'
require 'callcredit/checks/id_enhanced'
require 'callcredit/middleware/check_response'

# Errors
require 'callcredit/errors/callcredit_error'
require 'callcredit/errors/api_error'
require 'callcredit/errors/authentication_error'
require 'callcredit/errors/invalid_request_error'
require 'callcredit/errors/invalid_response_error'

module Callcredit
  def self.configure(&block)
    @config = Config.new(&block)
  end

  def self.id_enhanced_check(*args)
    client.id_enhanced_check(*args)
  end

  def self.perform_check(*args)
    client.perform_check(*args)
  end

  # Require configuration before use
  def self.config
    if @config
      @config
    else
      msg = "No config found. Use Callcredit.configure to set username, " +
            "password, company and application name. See " +
            "https://github.com/gocardless/callcredit-ruby for details."
      raise CallcreditError.new(msg)
    end
  end

  def self.client
    @client ||= Client.new(config)
  end
  private_class_method :client
end

