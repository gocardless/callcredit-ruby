module Callcredit
  class Response
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
      @response_data["Results"]["Result"]["Displays"]["InputData"]
    end

    def result
      @response_data["Results"]["Result"]["Displays"]["IdentityCheck"]
    end

    def warnings
      @response_data["Results"]["Result"]["Displays"]["Warnings"]
    end

    def full_result
      @response_data["Results"]["Result"]["Displays"]
    end
  end
end
