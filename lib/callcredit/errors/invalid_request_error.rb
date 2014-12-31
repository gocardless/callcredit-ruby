module Callcredit
  class InvalidRequestError < CallcreditError
    attr_reader :param

    def initialize(message, param, status = nil, response = nil)
      super(message, status, response)
      @param = param
    end
  end
end
