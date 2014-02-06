module Callcredit
  class ApiError < CallcreditError
    attr_reader :response, :status, :errors

    def initialize(response)
      @response = response
      @status = response[:status]
      body = response[:body]["Results"] rescue nil
      if body.is_a? Hash
        @errors = body["Errors"].map { |_,v| v["__content__"] }
      else
        @errors = "Response did not contain <Results> tag"
      end
    end

    def to_s
      "#{super} [#{self.status}] #{self.errors}"
    end
  end
end
