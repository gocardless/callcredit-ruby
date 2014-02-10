module Callcredit
  class CheckResponse
    def initialize(response_data)
      @response_data = response_data
    end

    def rid
      @response_data["Results"]["Result"]["RID"]
    end

    def pid
      @response_data["Results"]["Result"]["PID"]
    end

    def input
      self.input = @response_data["Results"]["Result"]["Displays"]["InputData"]
    end

    def result
      self.result = @response_data["Results"]["Result"]["Displays"]["IdentityCheck"]
    end
  end
end
