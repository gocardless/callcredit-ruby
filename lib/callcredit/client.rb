require 'callcredit/connection'
require 'callcredit/request'

module Callcredit
  class Client
    include Connection
    include Request

    attr_accessor *Callcredit::Configuration::VALID_OPTIONS_KEYS

    # Creates a new client
    def initialize(options={})
      options = Callcredit.options.merge(options)

      Callcredit::Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end
  end
end