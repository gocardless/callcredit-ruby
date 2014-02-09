require 'faraday_middleware'
require 'nokogiri'

require 'callcredit/config'
require 'callcredit/request'
require 'callcredit/constants'
require 'callcredit/client'
require 'callcredit/checks/id_enhanced'
require 'callcredit/middleware/check_response'
require 'callcredit/util'
require 'callcredit/versions'

# Errors
require 'callcredit/errors/callcredit_error'
require 'callcredit/errors/api_error'
require 'callcredit/errors/authentication_error'
require 'callcredit/errors/invalid_request_error'

module Callcredit
  def self.configure(&block)
    @config = Config.new(&block)
  end

  def self.id_check
    client.id_check
  end

  private
  def self.client
    @client ||= Client.new(config)
  end

  def self.config
    @config ||= Config.new
  end
end

