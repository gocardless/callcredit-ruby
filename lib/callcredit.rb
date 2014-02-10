require 'faraday_middleware'
require 'nokogiri'

require 'callcredit/version'
require 'callcredit/util'
require 'callcredit/config'
require 'callcredit/request'
require 'callcredit/constants'
require 'callcredit/client'
require 'callcredit/checks/id_enhanced'
require 'callcredit/middleware/check_response'

# Errors
require 'callcredit/errors/callcredit_error'
require 'callcredit/errors/api_error'
require 'callcredit/errors/authentication_error'
require 'callcredit/errors/invalid_request_error'

module Callcredit
  def self.configure(&block)
    @config = Config.new(&block)
  end

  def self.id_enhanced_check(check_data)
    client.id_enhanced_check(check_data)
  end

  def self.client
    @client ||= Client.new(config)
  end
  private_class_method :client

  def self.config
    @config ||= Config.new
  end
  private_class_method :config
end

