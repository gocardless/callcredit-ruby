module Callcredit
  class CallcreditError < StandardError
    attr_reader :message
    attr_reader :status
    attr_reader :response

    def initialize(message = nil, status = nil, response = nil)
      @message = message
      @status = status
      @response = response
    end

    def response_body
      response.fetch(:body, nil) if response.responds_to?(:fetch)
    end

    def to_s
      status_string = @status.nil? ? "" : "(Status #{@status}) "
      "#{status_string}#{@message}"
    end
  end
end
