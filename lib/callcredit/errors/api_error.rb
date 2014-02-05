module Callcredit
  class ApiError < CallcreditError
    attr_reader :response, :http_status, :message

    def initialize(response)
      @response = response
      @http_status = response[:status]
      body = MultiXml.decode(response[:body]) rescue nil
      @message = body.is_a?(Hash) ? body["message"] : "Unknown error"
    end

    def to_s
      "#{super} [#{self.http_status}] #{self.message}"
    end
  end
end
