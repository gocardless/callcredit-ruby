module Callcredit
  class CallcreditError < StandardError
    attr_reader :message
    attr_reader :status
    attr_reader :response_body

    def initialize(message=nil, status=nil, response=nil)
      @message = message
      @status = status
      @response_body = response_body
    end

    def to_s
      status_string = @status.nil? ? "" : "(Status #{@status}) "
      "#{status_string}#{@message}"
    end
  end
end
